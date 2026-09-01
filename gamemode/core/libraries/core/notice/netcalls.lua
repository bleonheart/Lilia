if CLIENT then
    net.Receive("liaNotificationData", lia.notices.receiveNotify)
    net.Receive("liaNotifyLocal", lia.notices.receiveNotifyL)
end
