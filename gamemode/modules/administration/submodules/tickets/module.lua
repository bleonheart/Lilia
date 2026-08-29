MODULE.Name = "Tickets"
MODULE.author = "Samael"
MODULE.NetworkStrings = {"liaActiveTickets", "liaClearAllTicketFrames", "liaRequestActiveTickets", "liaRequestTicketsCount", "liaTicketsCount", "liaTicketSystem", "liaTicketSystemClaim", "liaTicketSystemClose", "liaViewClaims",}
MODULE.Privileges = {
    ["alwaysSeeTickets"] = {
        Name = "Always See Tickets",
        MinAccess = "superadmin",
        Category = "Tickets",
    },
}
