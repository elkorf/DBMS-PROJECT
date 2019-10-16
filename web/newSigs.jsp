<%-- 
    Document   : newSigs
    Created on : 2 Oct, 2019, 1:18:03 AM
    Author     : elkorf
--%>
<%@include file="sessioncheck.jsp" %>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<html>
<head>
    <title>New SIGs</title>
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
	<link rel="stylesheet" href="css/newSigs.css">        
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
  <a href="newSigs.jsp" class="active" id="newSigs">SIGs</a>
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
  <a href="newEvents.jsp" id="newEvents">Events</a>
  <a href="myContributions.jsp" id="myContributions">My Contributions</a>
  
</div>
<!--------------------------------------content -------------------------------->

<div class="content">
    <%@include file="messages.jsp"%>
<div class="text-center">
<%
    try{
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
    
        ResultSet rs = null,rs2 = null , rs3=null;
        Statement st = con.createStatement();
        Statement st2 = con.createStatement();
        Statement st3 = con.createStatement();
        
        String query = "Select * from `group_details` order by date_created desc";
        rs = st2.executeQuery(query);

        int flag = 0;//flag to indicate whether a person is member of a group or not
        
        while(rs.next())
        {
            rs2 = st.executeQuery("select count(*) as count from `group_members` where group_id = '"+rs.getString("group_id")+"' ");
            rs2.next();
            rs3 = st3.executeQuery("select user_id from group_members where user_id ='"+session.getAttribute("uid")+"' and group_id = '"+rs.getString("group_id")+"' ");
            if(rs3.next())  //set the result flag
                flag = 1;
            else 
                flag = 0;
        %>  
        <div class='card'>
            <div class="card-header col-md-12 text-left">
                    text created time and other stuffs
            </div>
            <div class="col-md-12">  
                <div class="panel panel-default row card-text">
                    <div class="panel-heading col-md-4">
                        <h1 class="text-uppercase"><%=rs.getString("group_name")%></h1>
                        <div class="text-muted text-capitalize">
                            <h3>Created By : <%=rs.getString("created_by")%></h3>
                            <h4>Total Members : <%=rs2.getString("count")%></h4>
                        </div>
                    </div>
                    <div class="panel-body col-md-4">
                        <%=rs.getString("description")%>
                    </div>
                    <div class="panel-footer col-md-4 text-center">
                        <%
                            if(flag == 0){
                        %>
                        <a href="JoinGroup?sigid=<%=rs.getString("group_id")%>" class="btn btn-lg" >Join</a>
                        <%}else{%>
                        <a href="groupContentPosts.jsp?sigid=<%=rs.getString("group_id")%>" class="btn btn-lg" >Already Joined Open</a>
                        <%}%>
                        <a href="groupDashboard.jsp?sigid=<%=rs.getString("group_id")%>" class="btn btn-lg" >Details</a>
                    </div>     
                </div>
             </div>             
            <div class="card-footer col-md-12 text-left">
                    Created on: <%=rs.getString("date_created")%>
            </div>            
        </div>
                        
            <%
        }
        con.close();
    }catch(Exception ex){
        System.out.println("Exception occured while fetching sigs of user: "+ex.toString());
        response.sendRedirect("logout.jsp");
    }
%>

<!--new event section-->
<button type="button" style="bottom:1px;right:25px;position:fixed;" class="btn btn-info btn-lg shadow-lg p-3 mb-5 rounded" data-toggle="modal" data-target="#newSig">
  Create a SIG
</button>

<!-- Modal -->
<div class="modal fade" id="newSig" tabindex="-1" role="dialog" aria-labelledby="newSig" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered"  role="document">
    <div class="modal-content " style="background:#f8fafb">
      <div class="modal-header text-center">
        <ul class="nav nav-tabs nav-justified">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="modal" data-target="write">Details:</a>
            </li>   
        </ul>  
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
        
    <form action="CreateSig" method="post">
      <div class="modal-body" id="#write" style="min-height:300px;">
          
          <div style="padding-bottom: 2vh;">
            <input type="text" class="form-control" autocomplete="off" name="grpid" id="grpid" placeholder="Sig Id" onkeyup="chkGid(this.value);" required>
            <div id="msg" style="float:left"></div>
          </div>  
        
          <div style="padding-bottom: 2vh;">
            <input type="text" name="gname" required placeholder="Group Name" style="width: 100%;"/>
          </div>
          <div>
            <textarea style="min-height: 150px; width: 100%;" placeholder="Describe Your Group" required name="description"></textarea>
          </div>
      </div>
        
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <input type="submit" value="Create Group" class="btn btn-success" />
        </form>
      </div>
    </div>
  </div>
</div>

</div>
<!-- end of content section-->
<script src="js/sidebar_size.js"></script>                                          	
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script>
            var xmlHttp;

            function chkGid(inputString) {
                if (inputString.length == 0) {
                    document.getElementById("msg").innerHTML = "";
                    return;
                }
                try {
                    if (window.XMLHttpRequest)
                        xmlHttp = new XMLHttpRequest();
                    else if (window.ActiveXObject)
                        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                    if (!xmlHttp || xmlHttp == null) {
                        return;
                    }
                    var url = "LiveValidateGid?gid=" + inputString; 
                    xmlHttp.onreadystatechange = StateChanged;
                    xmlHttp.open("GET", url, true);
                    xmlHttp.send(null);
                } catch (e) {
                    document.getElementById("msg").innerHTML = "An error occured";
                }
            }
            
            function StateChanged() {
                if ((xmlHttp.readyState == 4) && (xmlHttp.status == 200)) {
                    var res = String(xmlHttp.responseText);
                    var vres = "Group Id is available";
                    var n = res.localeCompare(vres);
                    
                    if(n == -1)
                    {
                        document.getElementById("msg").innerHTML = res;
                        document.getElementById("grpid").style.border = "1px solid red";
                        document.getElementById("msg").style.color = "red";
                    }else{

                        document.getElementById("msg").innerHTML = res;
                        document.getElementById("msg").style.color = "green";
                        document.getElementById("grpid").style.border = "1px solid green";
                    }
                    
//                    document.getElementById("userid").style.border = "1px solid red";
                }
            }
</script>
</body>
</html>
