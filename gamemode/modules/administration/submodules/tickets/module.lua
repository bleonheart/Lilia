if CLIENT then TicketFrames = {} end
MODULE.name = "ticketsModuleName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "ticketSystemDescription"
MODULE.Privileges = {
    {
        Name = L("alwaysSeeTickets"),
        ID = "alwaysSeeTickets",
        MinAccess = "superadmin",
        Category = "tickets",
    },
}
