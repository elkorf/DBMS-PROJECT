<%-- 
    Document   : newEvents
    Created on : 2 Oct, 2019, 1:18:03 AM
    Author     : elkorf
--%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<html>
<head>
    <title>Live Events</title>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Fonts -->
 	<link href="lib/font/montserrat.css" rel="stylesheet" type="text/css">
  	<link href="lib/font/lato.css" rel="stylesheet" type="text/css">
  	
  	<!--Bootstrap-->
  	<link rel="stylesheet" href="lib/bootstrap/css/bootstrap.min.css">

	<!--Css-->
	<link rel="stylesheet" href="css/dashboard.css">
</head>
<body id="page-top">

<!--Navigation bar-->
	<nav class="navbar navbar-expand navbar-dark bg-dark fixed-top">
		<div id="menu_icon">
		<a href="#home"  class="navbar-brand mr-1" onclick="opensidebar()"><img src="img/menu_icon1.png" style="height:20px;width:20px"></img></a>
		</div>                                                        
	    <a class="navbar-brand mr-1" href="home.jsp">#SIGMS</a>
		<!-- Navbar Search -->
		<form class="d-none d-md-inline-block form-inline ml-auto mr-md-3 my-md-0" style="visibility:hidden;">
		    <div class="input-group">
				<input type="text" class="form-control" placeholder="Search for..." aria-label="Search" aria-describedby="basic-addon2" style="font-size:12px;width: 200px;">
				<div class="input-group-append">
			  		<button class="btn btn-primary" type="button">
			    		<span class="glyphicon glyphicon-search"></span>
			  		</button>
				</div>
		    </div>
		</form>

    <!-- Navbar -->
    <ul class="navbar-nav ml-auto ml-md-0">
	    <li style="visibility:hidden;">
                    <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="badge badge-success">9+</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="alertsDropdown">
                      <a class="dropdown-item" href="#">Action</a>
                      <a class="dropdown-item" href="#">Another action</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="#">Something else here</a>
                    </div>
            </li>
            <li class="nav-item dropdown" style="visibility:hidden;">
                    <a class="nav-link dropdown-toggle" href="#" id="messagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      <span class="badge badge-danger">7+</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="messagesDropdown">
                      <a class="dropdown-item" href="#">Action</a>
                      <a class="dropdown-item" href="#">Another action</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="#">Something else here</a>
                    </div>
            </li>
            <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="badge badge-danger">Profile</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">	
                      <a class="dropdown-item" href="#">Settings</a>
                      <a class="dropdown-item" href="#">Activity Log</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="logout.jsp">Logout</a>
                    </div>
            </li>
	</ul>
	</nav>

		

<!----------Side bar----------------->

		
<div class="sidebar bg-dark" id="mySidebar"> 						<!--C-->
  <div class="closeSideBarButton" id="closeSection">
      <button onclick="closeSideBar()" style="float:right;background:grey;border:0;radius:30">x</button>   
  </div>										<!--C-->
  <a href="home.jsp" id="home">Home</a>
  <a href="newSigs.jsp" id="newSigs">SIGs</a>
  <a href="mySigs.jsp" id="mySigs">My SIGs</a>
  <%
      String sig = (session.getAttribute("sigid") != null) ? session.getAttribute("sigid").toString() : "null";
      if(!sig.equals("null"))
      {
  %>
        <a href="groupDashboard.jsp"><%=session.getAttribute("sigid")%></a>
  <%
      }
  %>
  <a href="newEvents.jsp" id="newEvents" class="active">Events</a>
  <a href="myContributions.jsp" id="myContributions">My Contributions</a>
  
</div>

<!--------------------------------------content -------------------------------->
<div class="content">
    <div class="row ">
        <%@include file="messages.jsp"%>
<%  
    ResultSet rsev = null; //resultset for event
    ResultSet rsgrp = null; //resultset for group
    
    try{
        
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
        
        Statement st = con.createStatement();   //for event details
        
        rsev = st.executeQuery("select * from event order by posted_on desc");

        int evcnt = 0;

        while(rsev.next()){
            evcnt++;
            Statement st2 = con.createStatement();
            Statement st3 = con.createStatement();
            ResultSet usr = st3.executeQuery("select name from users where user_id = '"+rsev.getString("user_id")+"' ");
            usr.next();
            rsgrp = null;
            rsgrp = st2.executeQuery("select group_name from group_details where group_id='"+rsev.getString("group_id")+"' ");
            rsgrp.next();
%>

                    <div class="col-md-4" style="padding-bottom: 2vh;">
                        <div class="card shadow bg-white rounded features-card">
                            <div class="card-body text-center text-bold">
                                <h4 class="card-title"><%=rsev.getString("event_name")%></h4>
                                <table class="table-hover">
                                    <tbody>
                                        <tr>
                                            <td class="card-text">Group</td>
                                            <td class="card-text"><%=rsgrp.getString("group_name")%></td>
                                        </tr>
                                        <tr>
                                            <td class="card-text">Details</td>
                                            <td class="card-text"><%=rsev.getString("details")%></td>
                                        </tr>
                                        <tr>
                                            <td class="card-text">Venue</td>
                                            <td class="card-text"><%=rsev.getString("venue")%></td>
                                        </tr>
                                        <tr>
                                            <td class="card-text">Date</td>
                                            <td class="card-text"><%=rsev.getString("date")%></td>
                                        </tr>
                                        <tr>
                                            <td class="card-text">Organizer</td>
                                            <td class="card-text"><%=usr.getString("name")%></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="card-footer text-muted text-center">
                                Updated on :<%=rsev.getString("posted_on")%>
                                <button class="btn btn-warning" onclick="location.href='Mailer?msg=<%=rsev.getString("event_name")%>&page=newEvents.jsp'">Get Notification</button>
                            </div>
                        </div>
                    </div>

<%
            }//end while
            if(evcnt == 0){
                out.println("<h1>No events yet! Go ahead and Organize!</h1>");
            }
    }catch(Exception ex){
        System.out.println("Exception occured while rendering events! "+ex);
    }
%>

</div>
<!--END EVENT DISPLAY--> 
<!-- end of content section-->
</div>
<script src="lib/js/sidebar_size.js"></script>                                          	
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
