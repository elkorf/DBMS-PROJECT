<%-- 
    Document   : newPassword
    Created on : 15 Oct, 2019, 1:35:36 AM
    Author     : elkorf
--%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<html>
<head>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">

  	<!--Bootstrap-->
  	<link rel="stylesheet" href="lib/bootstrap/css/bootstrap.min.css">

	<!--Css-->
	<link rel="stylesheet" href="css/dashboard.css">

</head>
<body id="page-top" style="background: #f4eef5">

<!--Navigation bar-->
	<nav class="navbar navbar-expand navbar-dark bg-dark fixed-top">                                                       
	    <a class="navbar-brand mr-1" href="home.jsp">#SIGMS</a>
	</nav>

<div style="margin-top: 200px;">
<center>
   <%@include file="messages.jsp"%>
<%
    if(request.getParameter("hash")!=null){
        String hash=request.getParameter("hash").trim();
//        String mail = request.getParameter("email").trim();
        String query="SELECT * FROM users WHERE password='"+hash+"'  ";
//         System.out.println("email: "+hash);
        try{
            Connection con = Dbconn.connect();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(query);
            if(rs.next()){
               
               
%>
    
<form action="ChangePass" method="post">        
    <div class="col-sm-4">
        <div class="card shadow bg-light rounded">
            <div class="card-body text-center text-bold">
                <div>
                    <input type="text" id="forgot" value="<%=rs.getString("user_id")%>" name="username" style="visibility:hidden"/>
                </div>
                <div>
                    <input type="password" id="forgot" placeholder="New Password" name="newpass" required>
                </div>
                <br>
                <div>
                    <input type="password" id="forgot" placeholder="Confirm Password" name="confirmpass" required>
                </div>
                <br>
                <div>
                    <button class="btn btn-info btn-lg">Cancel</button>
                    <button type="submit" class="btn btn-danger btn-lg">Reset</button>
                </div>    
            </div>
        </div>
    </div>
</form>   
</center>    

<%
    
        
            }else{
                out.print("<h1>Incorrect hash</h1>");
                //response.sendRedirect("forgotPassword.jsp");
              //  return;
            }
        }catch(Exception ex){
            //response.sendRedirect("forgotPassword.jsp");
            System.out.println("Error while forgot password "+ex);
            ex.printStackTrace();
        }
    }else{
    
%>
    <br><br> <h1>Password Changed</h1>
<%}%>
<!-- end of content section-->
</div>

<script src="lib/js/sidebar_size.js"></script>                                            
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>     
