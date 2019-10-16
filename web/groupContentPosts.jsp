<%@page import="java.sql.CallableStatement"%>
<%@include file="sessioncheck.jsp" %>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
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
    
    ResultSet rsgrp = null , rspost = null , rscomment = null ; //resultsets for grp post and comments
    
    try{
        
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
        
        Statement st = con.createStatement();   //for group details
        Statement st2 = con.createStatement();  //for post details
        Statement st3 = con.createStatement();  //for user name for post
        
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
	<button class="tabactivelink" onclick="location.href = 'groupContentPosts.jsp';">Posts</button>
	<button class="tabpassivelink" onclick="location.href = 'groupContentQuestions.jsp';">Questions</button>
	<button class="tabpassivelink" onclick="location.href = 'groupContentEvents.jsp';">Events</button>
</div>
<br>

    <!----------end of tabs tabs----------->
<%
            //get posts
            
            int pcounter = 0;   //counter to make post id dynamic
            
            rspost = st2.executeQuery("Select * from `post` where group_id='"+session.getAttribute("sigid")+"' order by posted_on desc");
            while(rspost.next())
            {
                //get users name from users table
                ResultSet rsuser = st3.executeQuery("select name from `users` where user_id='"+rspost.getString("user_id")+"' ");
                rsuser.next();
                String uname = rsuser.getString("name");
                rsuser = null;
%>
                <div class="row question" id="question<%=pcounter%>">
                        <div class="profile">
                        <img src="img/user-solid.svg" style="width:40px;height: 40px;" class="card rounded-circle mx-auto d-block">
                        </div>
                        <div class="text">
                            <div class="card shadow-lg bg-white rounded">
                                    <div class="card-header">
                                            <h5 class="card-title">Asked By: <%=uname%></h5>
                                    </div>
                                    <div class="card-body card-question">
                                            <p class="card-text">
                                                    <code class="language-c">
                                                            <%=rspost.getString("post")%>
                                                    </code>
                                            </p>
                                    </div>	
                                    <div class="card-footer">
                                            <div>
                                                    <div style="float: left;"><h5 class="card-text">Asked On: <%=rspost.getString("posted_on")%></h5></div>
                                                    <div style="float:right;">
                                                        <button  style="float:right;"data-toggle="collapse" class="btn btn-outline-dark" data-target="#answer<%=pcounter%>">Show Comments</button>
                                                        <button style="float:right;visibility:hidden;" class="btn btn-outline-dark">Add Comment</button>
                                                    </div>
                                            </div>
                                    </div>
                            </div>
                        </div>
                </div>
                <br>
                
                <%
                    //get comments for each post
                    
                    //create callable statement object for calling procedure
                    String query = "{ call getComments(?) }";
                    CallableStatement st4 = con.prepareCall(query);  //for comments
                    
                    //set parameter
                    st4.setString(1, rspost.getString("post_id").toString());
                    
                    //execute call
                    ResultSet rscmnt = st4.executeQuery();
                    
                    //loop
                    while(rscmnt.next())
                    {
                        rsuser = st3.executeQuery("select name from `users` where user_id='"+rscmnt.getString("user_id")+"' ");
                        rsuser.next();
                        String usrname = rsuser.getString("name");
                        rsuser = null;
                %>
                <div class="row answer collapse" id="answer<%=pcounter%>">
                    <div class="profile">
                        <img src="img/user-solid.svg" style="width:40px;height: 40px;" class="card rounded-circle mx-auto d-block">
                    </div>
                        <div class="text">
                        <div class="card shadow bg-white rounded">
                                <div class="card-header">
                                    <h5 class="card-title"><%=usrname%></h5>
                                </div>
                                <div class="card-body card-question">
                                        <p class="card-text">
                                                <code class="language-c">
                                                    <%=rscmnt.getString("comment")%>
                                                </code>
                                        </p>
                                </div>
                                <div class="card-footer">
                                        <h5 class="card-text"><%=rscmnt.getString("posted_on")%></h5>
                                </div>	
                        </div>
                    </div>
                </div>
                <br>
                
<%
                    }//end while for comments loop
                    if(ismember){
%>
                        <!--the add coment div start-->
                        <div class="row answer collapse" id="answer<%=pcounter%>">
                            <div class="profile">
                                <img src="img/user-solid.svg" style="width:40px;height: 40px;" class="card rounded-circle mx-auto d-block">
                            </div>
                                <div class="text">
                                <div class="card shadow bg-white rounded">
                                        <div class="card-header">
                                            <h5 class="card-title">Add Your Comment</h5>
                                        </div>
                                        <div class="card-body card-question">
                                                <form action="AddComment" method="POST">
                                                    <textarea style="min-height: 100px; width: 100%;" placeholder="Write or drag content here..." required name="comment-data"></textarea>
                                                    <input type="text" style="visibility:hidden" value="<%=rspost.getString("post_id").toString()%>" name="post_id"/>
                                        </div>
                                        <div class="card-footer text-center">
                                                    <input type="submit" class="btn btn-primary"  value="Add Comment"></input>
                                                </form>
                                        </div>	
                                </div>
                            </div>
                        </div>
                        <br>
                        <!--the add comment div end-->
<%
                    } //end cmnt blk if

                pcounter++; //increment post counter

            }//end while of post fetch
            if(pcounter == 0){   //pcounter will remain 0 if there are no posts
                //display a proper message here
                out.print("<h1>NO POSTS YET GO AHEAD AND POST!</h1>");
            }
            

                if(ismember){//display add post btn only if user is member of group
%>
                    <!--ADD POST BTN-->
                    <button type="button" style="bottom:1px;right:25px;position:fixed;" class="btn btn-info btn-lg shadow-lg p-3 mb-5 rounded" data-toggle="modal" data-target="#newPost">
                      Add Post
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
        System.out.println("Exception Occured while getting grp details on group posts page: "+ex.toString());
    }

%>

<!-- Modal -->
<div class="modal fade" id="newPost" tabindex="-1" role="dialog" aria-labelledby="newPost" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered"  role="document">
    <div class="modal-content " style="background:#f8fafb">
      <div class="modal-header text-center">
        <ul class="nav nav-tabs nav-justified">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="modal" data-target="write">Write</a>
            </li>
<!--            <li class="nav-item">
                <a class="nav-link" data-toggle="modal" data-target="">Preview</a>
            </li>
            <li class="nav-item">
                we can put more items here
            </li>    -->
        </ul>  
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="AddPost" method="POST">
        <div class="modal-body" id="#write" style="min-height:300px;">
            <textarea style="min-height: 300px; width: 100%;" placeholder="Write or drag content here..." required name="post-data"></textarea>
        </div> 
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <input type="submit" class="btn btn-primary"  value="Add Post"></input>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- end of content section-->
</div>
<script src="js/sidebar_size.js"></script>
<!--<script src="https://use.fontawesome.com/f2ba1cc551.js"></script>-->
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
