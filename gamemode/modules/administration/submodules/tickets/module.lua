if CLIENT then TicketFrames = {} end
MODULE.name = "Tickets"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("ticketSystemDescription")
MODULE.Privileges = {
    {
        Name = L("alwaysSeeTickets"),
        ID = "alwaysSeeTickets",
        MinAccess = "superadmin",
        Category = "tickets",
    },
}
