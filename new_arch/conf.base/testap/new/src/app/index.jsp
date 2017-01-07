<%@ page contentType="text/html; charset=euc-jp" %>
<%
// 現在の時刻を取得
java.util.Date nowTime = new java.util.Date();

String remoteHostUrl = request.getScheme() + ":" + request.getServerName();
if (request.getRemotePort() != 80) {
    remoteHostUrl += (":" + String.valueOf(request.getServerPort()));
}
remoteHostUrl += ("/" + pageContext.getServletContext().getServletContextName());
%>

<html>
<body>
<p>
Wildfly Connected!
</p> <p>
instance name : __MY_NAME__
</p> <p>
現在の時刻は <strong><%= nowTime %></strong> です。
</p> <p>
server : <strong><%= remoteHostUrl %></strong> です。
</p>
</body>
</html>
