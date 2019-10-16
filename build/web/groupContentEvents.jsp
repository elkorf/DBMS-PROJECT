<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<%@include file="sessioncheck.jsp" %>
<html>
<head>
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
	<link rel="stylesheet" href="css/tabs.css">
        <link rel="stylesheet" href="css/statistics.css">
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

		
<%
    //the following block of code sets the sigid as a session varibale to use it to access a perticlar sig handels corner cases
    try{
        String sigid = (session.getAttribute("sigid") != null) ? session.getAttribute("sigid").toString() : null;
        String parameter = (request.getParameter("sigid") != null) ? request.getParameter("sigid").toString() : "null";
        if(!parameter.equals("null"))
            session.setAttribute("sigid", parameter);
    }catch(Exception e){
        System.out.println("Exception Occured while setting group id as session variable on group posts page: "+e.toString());
    }
%>

<!----------Side bar----------------->

		
<div class="sidebar bg-dark" id="mySidebar"> 						
  <div class="closeSideBarButton" id="closeSection">
      <button onclick="closeSideBar()" style="float:right;background:grey;border:0;radius:30">x</button>   
  </div>										
  <a href="home.jsp" id="home">Home</a>
  <a href="newSigs.jsp" id="newSigs">SIGs</a>
  <a href="mySigs.jsp" id="mySigs">My SIGs</a>
  <%
      String sig = (session.getAttribute("sigid") != null) ? session.getAttribute("sigid").toString() : "null";
      if(!sig.equals("null"))
      {
  %>
        <a href="groupDashboard.jsp" class="active"><%=session.getAttribute("sigid")%></a>
  <%
      }
  %>
  <a href="newEvents.jsp" id="newEvents">Events</a>
  <a href="myContributions.jsp" id="myContributions">My Contributions</a>
  
</div>

<!------------------------content-------------------------------->

<%
    
    //code for getting all the data to be rendered in this page
    
    ResultSet rsgrp = null , rsev = null; //resultsets for grp and event
    
    try{
        
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
        
        Statement st = con.createStatement();   //for group details
        Statement st2 = con.createStatement();  //for event details
        
        rsgrp = st.executeQuery("select * from group_details where group_id = '"+session.getAttribute("sigid")+"' ");
        if(!rsgrp.next())   //if there is nothing in resultset that mens there is no such sig
        {
            session.setAttribute("alert_message","You are trying to access a sig that doesnt exist!");
            session.setAttribute("alert_type","warning");
            response.sendRedirect("home.jsp");
        }else{
            
            //check if user is already membe of that group if not give join option
            String sql = "{ call isMember(?,?) }";
            CallableStatement callst = con.prepareCall(sql);  //for answers

            //set parameters
            callst.setString(1, session.getAttribute("uid").toString());
            callst.setString(2, rsgrp.getString("group_id"));

            //execute call
            ResultSet rsmem = callst.executeQuery();

            Boolean ismember = false;
            //set flag if user is member of a group
            if(rsmem.next())
                ismember = true;
        
%>

<div class="content">
<!----- tabs-------------->
<%@include file="messages.jsp"%>
<div id="banner" style="background:#a6e1ec;max-height: 10vh;  padding-top:3vh">
        <div>
            <h2 class="text-center"><%=rsgrp.getString("group_name").toUpperCase()%></h2><br><br>
<!--            <h3 style=" margin:2vw;" class="text-center"><%=rsgrp.getString("description")%></h3>-->
        </div>
</div>
<div class="fixedElement navbar navbar-expand-md navbar-dark bg-dark rouded" id="tabs">
	<button class="tabpassivelink" onclick="location.href = 'groupContentPosts.jsp';">Posts</button>
	<button class="tabpassivelink" onclick="location.href = 'groupContentQuestions.jsp';">Questions</button>
	<button class="tabactivelink" onclick="location.href = 'groupContentEvents.jsp';">Events</button>
</div>
    <!----------end of tabs tabs----------->
<br>
<div class="row ">
<%  
            rsev = st2.executeQuery("select * from event where group_id = '"+session.getAttribute("sigid").toString()+"' ");
            
            int evcnt = 0;
            
            while(rsev.next()){
                evcnt++;
                Statement st3 = con.createStatement();
                ResultSet usr = st3.executeQuery("select name from users where user_id = '"+rsev.getString("user_id")+"' ");
                usr.next();
%>

                    <div class="col-sm-3">
                        <div class="card shadow bg-white rounded features-card">
                            <div class="card-body text-center text-bold">
                                <h4 class="card-title"><%=rsev.getString("event_name")%></h4>
                                <table class="table-hover">
                                    <tbody>
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
                            <div class="card-footer text-muted text-center" style="max-height: 15vh">
                                Updated on :<%=rsev.getString("posted_on")%>    

                                <button class="btn btn-warning" onclick="location.href='Mailer?msg=<%=rsev.getString("event_name")%>&page=groupContentEvents.jsp'">Get Notification</button>
                   
                            </div>
                        </div>
                    </div>

<%
            }//end while
            if(evcnt == 0){
                out.println("<h1>No events yet! Go ahead and Organize!</h1>");
            }
            
            if(ismember){
%>
                <!--new event section-->
                <button type="button" style="bottom:1px;right:25px;position:fixed;" class="btn btn-info btn-lg shadow-lg p-3 mb-5 rounded" data-toggle="modal" data-target="#newQuestion">
                  New Event
                </button>
<%
                }else{
%>
                    <button type="button" style="bottom:1px;right:25px;position:fixed;" class="btn btn-success btn-lg shadow-lg p-3 mb-5 rounded" onclick="location.href = 'JoinGroup?sigid=<%=rsgrp.getString("group_id")%>';">
                      Join Group To Interact
                    </button>    
<%
                }//end is member blk

        }//end else
    }catch(Exception ex){
        System.out.println("Exception occured while rendering events! "+ex);
    }
%>

</div>
<!--END EVENT DISPLAY-->    


<!-- Modal -->
<div class="modal fade" id="newQuestion" tabindex="-1" role="dialog" aria-labelledby="newPost" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered"  role="document">
    <div class="modal-content " style="background:#f8fafb">
      <div class="modal-header text-center">
        <ul class="nav nav-tabs nav-justified">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="modal" data-target="write">Write</a>
            </li>   
        </ul>  
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <form action="AddEvent" method="post">
      <div class="modal-body" id="#write" style="min-height:300px;">
          <input type="text" name="evname" required placeholder="Event Name" style="width: 100%"/>
          <textarea style="min-height: 150px; width: 100%;" placeholder="Write or drag content here..." required name="description"></textarea>
          Venue:<input type="text" name="venue" required placeholder="Venue" style="width: 50%"/>
          Date: <input type="date" name="date" required placeholder="Date:" />
          
      </div>
        
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <input type="submit" class="btn btn-success" value="Create Event" />
        </form>
      </div>
    </div>
  </div>
</div>

<!-- end of content section-->
</div>
<script src="js/sidebar_size.js"></script>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
