<%
//RESETTING ALL SESSION ATTRIBUTES.
    session.setAttribute("username", null);
    session.setAttribute("uid", null);
    session.setAttribute("sigid", null);
    session.setAttribute("email", null);
    //session.invalidate();
    session.setAttribute("alert_message","Logged out successfully!");
    session.setAttribute("alert_type","success");
    response.sendRedirect("index.jsp");
%>

