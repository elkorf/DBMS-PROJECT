<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%

        String email=request.getParameter("email").trim();
        String query="SELECT * FROM users WHERE email='"+email+"'";
         System.out.println("email: "+email);
        try{
            Connection con = Dbconn.connect();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(query);
            if(rs.next()){
               String hash = rs.getString("password");
               //call the mail here
               String msg = "Visit this link to reset your password: http://localhost:22012/SIG/newPassword.jsp?hash="+hash;
               response.sendRedirect("Mailer?mail="+email+"&msg="+msg+"&page=forgotPassword.jsp");
               return;
            }else{
                System.out.print("something went wrong!");
                //response.sendRedirect("forgotPassword.jsp");
              //  return;
            }
        }catch(Exception ex){
            //response.sendRedirect("forgotPassword.jsp");
            System.out.println("Error whiile forgot password "+ex);
            ex.printStackTrace();
        }

%>