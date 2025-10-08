#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
import re
import json

def scrape_panel_methods(panel_name):
    """Scrape methods for a specific panel type"""
    # Try both the panel name and D-prefixed version
    urls_to_try = [
        f"https://wiki.facepunch.com/gmod/{panel_name}",
        f"https://wiki.facepunch.com/gmod/D{panel_name}"
    ]

    for url in urls_to_try:
        try:
            response = requests.get(url)
            if response.status_code == 200:
                soup = BeautifulSoup(response.text, 'html.parser')
                methods = []

                # Get all text content and parse method definitions
                text_content = soup.get_text()

                # Split by methods section
                lines = text_content.split('\n')
                in_methods_section = False

                # Try both panel name formats for matching
                name_patterns = [panel_name]
                if panel_name.startswith('D'):
                    name_patterns.append(panel_name[1:])  # Also try without D prefix
                else:
                    name_patterns.append(f'D{panel_name}')  # Also try with D prefix

                for line in lines:
                    line = line.strip()
                    if not line:
                        continue

                    if 'Methods' in line and any(pattern + ':' in text_content for pattern in name_patterns):
                        in_methods_section = True
                        continue
                    elif in_methods_section:
                        # Check if line starts with any of our name patterns
                        for pattern in name_patterns:
                            if line.startswith(pattern + ':') and '(' in line:
                                # Parse method signature and description from the same line
                                # Format is typically: "DImage:MethodName()Description text"
                                parts = line.split(')', 1)
                                if len(parts) == 2:
                                    signature = parts[0] + ')'
                                    description = parts[1].strip()
                                    methods.append({
                                        'signature': signature,
                                        'description': description
                                    })
                                break  # Found a match, no need to check other patterns

                if methods:
                    return methods

        except Exception as e:
            print(f"Error scraping {url}: {e}")
            continue

    return []

def format_method_markdown(panel_name, methods):
    """Format methods in the requested markdown format"""
    if not methods:
        return ""

    markdown = f"# {panel_name}\n\n"

    for method in methods:
        signature = method['signature']
        description = method['description']

        markdown += f"{signature}\n"
        if description:
            markdown += f"{description}\n"
        markdown += "\n"

    return markdown

def get_all_panel_types():
    """Get list of all panel types from the main page"""
    url = "https://wiki.facepunch.com/gmod/"

    try:
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        # Find the panels section
        panels_section = None
        for details in soup.find_all('details'):
            summary = details.find('summary')
            if summary and 'Panels 130' in summary.get_text():
                panels_section = details
                break

        if not panels_section:
            print("Could not find panels section")
            return []

        panel_types = []
        for link in panels_section.find_all('a'):
            href = link.get('href', '')
            if '/gmod/' in href and href != '/gmod/':
                panel_name = href.split('/')[-1]
                # Filter out method names (containing :) and other non-panel links
                # Also filter out very short names and names that look like methods
                if (panel_name and not panel_name.startswith('~') and
                    not ':' in panel_name and len(panel_name) > 2 and
                    not panel_name[0].islower()):  # Panel names should start with capital
                    panel_types.append(panel_name)

        return panel_types

    except Exception as e:
        print(f"Error getting panel types: {e}")
        return []

if __name__ == "__main__":
    # Get all panel types
    print("Getting panel types...")
    panel_types = get_all_panel_types()
    print(f"Found {len(panel_types)} panel types: {panel_types[:5]}...")  # Show first 5

    # Scrape methods for each panel type
    all_methods = {}
    for i, panel_type in enumerate(panel_types):
        print(f"Scraping {panel_type} ({i+1}/{len(panel_types)})...")
        methods = scrape_panel_methods(panel_type)
        print(f"  Found {len(methods)} methods")
        if methods:
            all_methods[panel_type] = methods

    # Format as markdown
    markdown_content = ""
    for panel_type, methods in all_methods.items():
        markdown_content += format_method_markdown(panel_type, methods)
        print(f"Formatted {panel_type} with {len(methods)} methods")

    # Save to file
    with open('panel_methods.md', 'w', encoding='utf-8') as f:
        f.write(markdown_content)

    print(f"Saved {len(all_methods)} panel types to panel_methods.md")
