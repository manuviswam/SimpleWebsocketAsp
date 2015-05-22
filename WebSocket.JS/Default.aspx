<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebSocket.JS.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/jquery-1.9.1.js"></script>
    <script src="Scripts/modernizr-2.6.2.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script type="text/javascript">
    var socket;

    $(document).ready(function () {
        if (!Modernizr.websockets)
        {
            alert("This browser does not support web sockets");
        }

        socket = new WebSocket("ws://localhost:49464/WebSocketHandler.ashx");

        socket.addEventListener("open", function (evt) {
            $("#divHistory").append('<h3>Connection Opened with the server.</h3>');
        }, false);

        socket.addEventListener("close", function (evt) {
            $("#divHistory").append('<h3>Connection was closed. :' + evt.reason + '</h3>');
        }, false);

        socket.addEventListener("message", function (evt) {
            $("#divLastHitTime").html('<h4>Time of last message : ' + new Date($.now()) +'</h4>');
            $('#divLastMessage').html(evt.data);

            $('#divLastMessage').dialog({
                autoOpen: true,
                show: "blind",
                hide: "explode",
                modal: true,
                open: function (event, ui) {
                    setTimeout(function () {
                        $('#divLastMessage').dialog('close');
                    }, 3000);
                }
            });
        }, false);

        socket.addEventListener("error", function (evt) {
            alert('Error : ' + evt.message);
        }, false);

        $("#startButton").click(function () {
            if (socket.readyState == WebSocket.OPEN) {
                socket.send($("#myEmail").val());
            }
            else {
                $("#divHistory").append('<h3>The underlying connection is closed.</h3>');
            }
        });

        $("#endButton").click(function () {
            socket.close();
        });
    });
    </script>
</head>
<body>
    <form id="form1" runat="server">
            <div>
            <input id="myEmail" type="text" placeholder="Add your message here." />
            <input id="startButton" type="button" autofocus="autofocus" value="Start" />
            <input id="endButton" type="button" value="End" />
            <div id="divLastHitTime"></div>
            <div id="divHistory"></div>
            <div id="divLastMessage"></div>
        </div>  
    </form>
</body>
</html>
