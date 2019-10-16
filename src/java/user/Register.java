/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package user;

import db.Dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author manas
 */
public class Register extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        
        //response.setContentType("text/html;charset=UTF-8");
        HttpSession session=request.getSession(true);
        PrintWriter out=response.getWriter();
        
        String sql=null,name=null,email=null,uid=null,mobile=null,pass=null,repass=null;
        
        try{
            uid = request.getParameter("userid");
            name = request.getParameter("name");
            email  = request.getParameter("email").toString();
            mobile = request.getParameter("mobile");
            pass = request.getParameter("password");
            repass  = request.getParameter("repassword");
            
            //if password nad retyped password dont match that means the javascript validations have been manipulated
            if(!pass.equals(repass)){
                System.out.println("Someone tried to penetrate system! Detais: "+request.getRemoteAddr().toString()+"\n"+request.getRemoteHost());
                response.sendRedirect("index.jsp");
            }
            else{
                //do further db checks!
                //CONNECTING DATABASE
                Dbconn db=new Dbconn();
                Connection con =db.connect();
                
                //import the password encryptor and encrypt it
                EncryptPass ep = new EncryptPass();
                pass = ep.encrypt(pass);
                
                //first check if the username already exists
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("select * from users where user_id='"+uid+"'");
                
                if(rs.next()){
                    //user with same userid already exists!
                    session.setAttribute("flash_message","An error occured while registering new user please try again!");
                    session.setAttribute("flash_type","warning");
                    response.sendRedirect("register.jsp");
                }else{
                    //all fine register the user
                    String query = "insert into users (user_id,name,email,password,mobile_number) values('"+uid+"', '"+name+"', '"+email+"', '"+pass+"', '"+mobile+"')";
                    Statement st = con.createStatement();
                    int rc = st.executeUpdate(query);
                    
                    if(rc>0){   //rc willl be >0 if the row gets inserted
                        session.setAttribute("flash_message","You are registered now proceed to login!");
                        session.setAttribute("flash_type","success");
                        response.sendRedirect("index.jsp");
                    }else{
                        session.setAttribute("flash_message","An error occured while registering new user please try again!");
                        session.setAttribute("flash_type","warning");
                        response.sendRedirect("register.jsp");
                    }
                }
                con.close();
            }
        }catch(Exception e){
            System.out.println("Exception occured while registering user: "+e.toString());
            session.setAttribute("flash_message","An error occured while registering new user please try again after sometime!");
            session.setAttribute("flash_type","warning");
            response.sendRedirect("register.jsp");
        }finally{
            out.close();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet to register users on the system url pattern is /register";
    }// </editor-fold>

}
