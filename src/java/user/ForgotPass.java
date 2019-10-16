/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package user;

import db.Dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author elkorf
 */
public class ForgotPass extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
        
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        
        PrintWriter out = response.getWriter();
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
    }
  
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
