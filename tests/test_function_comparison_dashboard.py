import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "scripts" / "function_comparison_dashboard.py"
spec = importlib.util.spec_from_file_location("comparison_dashboard", SCRIPT)
dashboard = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dashboard)


def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def fixture_generator(tmp_path: Path):
    base = tmp_path / "Lilia" / "gamemode"
    docs = tmp_path / "Lilia" / "documentation"
    sam_root = tmp_path / "lilia_rp" / "modules"
    write(base / "languages" / "english.lua", 'return { test_name = "Test" }')
    write(docs / "docs" / "hooks" / "hooks.md", "## ExistingHook\n")
    write(docs / "docs" / "libraries" / "lia.util.md", "### doThing\n")
    write(base / "core" / "libraries" / "lia.util.lua", """
function lia.util.doThing(value) return value end
lia.util.otherThing = function(value) return value end
function lia.util.otherThing(value) return value end
hook.Add("FrameworkHook", "owner", function() end)
util.AddNetworkString("framework_to_module")
lia.config.add("feature_enabled", "Feature", true)
""")
    write(base / "modules" / "coremod" / "module.lua", "function MODULE:Start() end")
    write(sam_root / "consumer" / "module.lua", """
local util = lia.util
util.doThing(1)
hook.Run('FrameworkHook')
net.Start("framework_to_module") net.Send(player.GetAll())
net.Receive("module_to_framework", function() end)
local enabled = lia.config.get("feature_enabled", false)
function lia.missing.fromNeither() end
local playerMeta = FindMetaTable("Player")
function playerMeta:ModuleExample(value) return value end
""")
    write(sam_root / "consumer" / "server.lua", 'util.AddNetworkString("module_to_framework")\n')
    return dashboard.FunctionComparisonReportGenerator(
        base_path=str(base), docs_path=str(docs),
        language_file=str(base / "languages" / "english.lua"),
        modules_paths=[str(sam_root)],
    )


def test_shared_symbols_cover_namespaces_aliases_and_hooks(tmp_path):
    generator = fixture_generator(tmp_path)
    symbols = generator._extract_shared_symbols("""
function lia.util.one() end
lia.util.two = function() end
local util = lia.util
util.one()
hook.Add('OneHook', 'id', fn)
hook.Remove([[TwoHook]], 'id')
function MODULE:ThreeHook() end
""")
    assert {"lia.util.one", "lia.util.two"} <= symbols["functions"]
    assert "lia.util.one" in symbols["function_refs"]
    assert {"OneHook", "TwoHook", "ThreeHook"} <= symbols["hooks"]


def test_cross_library_rules_for_modules_net_hooks_and_config(tmp_path):
    generator = fixture_generator(tmp_path)
    modules = generator._scan_modules_for_undocumented()
    consumer = next(item for item in modules if item["module_name"] == "consumer" and item["module_scope"] == "module")
    assert "FrameworkHook" not in consumer["undoc_hooks"]
    assert "lia.util.doThing" not in consumer["undoc_functions"]
    assert "lia.missing.fromNeither" in consumer["undoc_functions"]
    assert "playerMeta:ModuleExample" in consumer["undoc_meta_functions"]

    defined, used, unused, missing, _ = generator._run_net_message_analysis()
    assert "framework_to_module" in defined and "framework_to_module" in used
    assert "module_to_framework" in defined and "module_to_framework" in used
    assert "framework_to_module" not in missing
    assert "module_to_framework" not in missing

    misregistered, module_missing, _ = generator._run_module_net_registration_analysis(defined, used)
    assert not misregistered
    assert not module_missing
    assert not generator._detect_undefined_config_get_calls()

    comparison = generator._run_function_comparison()
    assert any("lia.util.otherThing" in row.get("duplicate_functions", []) for row in comparison.values())


def test_markdown_report_scopes_and_invalid_targets(tmp_path):
    generator = fixture_generator(tmp_path)
    data = generator.run_all_analyses()
    meta_doc = tmp_path / "lilia_rp" / "modules" / "consumer" / "docs" / "meta.md"
    assert meta_doc.exists()
    assert "Meta documentation example" in meta_doc.read_text(encoding="utf-8")
    full = generator.generate_markdown_for_scope(data, "Fully Report Libraries")
    library = generator.generate_markdown_for_scope(data, "Report Library", "lia.util")
    lilia_module = generator.generate_markdown_for_scope(data, "Report Lilia Module", "coremod")
    sam_module = generator.generate_markdown_for_scope(data, "Report Module", "consumer")
    for report in (full, library, lilia_module, sam_module):
        assert "## Function Documentation Analysis" in report
        assert "## Hooks Documentation Analysis" in report
        assert "## Net Message Analysis" in report
        assert "## Config: Undefined lia.config.get Keys" in report
        assert "## Font Analysis" in report
    try:
        generator.generate_markdown_for_scope(data, "Report Module", "does-not-exist")
    except ValueError as exc:
        assert "Unknown Sam Module" in str(exc)
    else:
        raise AssertionError("invalid report target did not raise ValueError")


def test_save_reports_exports_each_external_module(tmp_path):
    generator = fixture_generator(tmp_path)
    data = generator.run_all_analyses()
    files = generator.save_reports(data)
    names = {Path(path).name for path in files}
    assert "lilia.md" in names
    assert "comparison_report.md" in names
    module_report = Path(next(path for path in files if Path(path).name == "comparison_report.md"))
    assert module_report.parent.name == "consumer"
    framework_report = Path(next(path for path in files if Path(path).name == "lilia.md"))
    assert "# Sam's Modules" not in framework_report.read_text(encoding="utf-8")


class DashboardTests(unittest.TestCase):
    def test_shared_symbols(self):
        with tempfile.TemporaryDirectory() as directory:
            test_shared_symbols_cover_namespaces_aliases_and_hooks(Path(directory))

    def test_cross_library_analysis(self):
        with tempfile.TemporaryDirectory() as directory:
            test_cross_library_rules_for_modules_net_hooks_and_config(Path(directory))

    def test_markdown_scopes(self):
        with tempfile.TemporaryDirectory() as directory:
            test_markdown_report_scopes_and_invalid_targets(Path(directory))

    def test_per_module_exports(self):
        with tempfile.TemporaryDirectory() as directory:
            test_save_reports_exports_each_external_module(Path(directory))


if __name__ == "__main__":
    # Make the file useful when launched directly as well as through unittest,
    # pytest, or an IDE test runner.
    unittest.main(verbosity=2)
