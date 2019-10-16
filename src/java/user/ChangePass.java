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
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author manas
 */
public class ChangePass extends HttpServlet {

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


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

        try{
            
            HttpSession session = request.getSession(true);
            
            String unme = request.getParameter("username").trim();
            String newpass = request.getParameter("newpass").trim();
            String confirmpass = request.getParameter("confirmpass").trim();

            System.out.println(unme+"   "+newpass+" "+confirmpass);
            
            if(newpass.equals(confirmpass)){
                
                 //CONNECTING DATABASE
                Dbconn db=new Dbconn();
                Connection con =db.connect();
                
                //import the password encryptor and encrypt it
                EncryptPass ep = new EncryptPass();
                newpass = ep.encrypt(newpass);
                
                Statement st = con.createStatement();
                
                int rs = st.executeUpdate("update users set password = '"+newpass+"' where user_id='"+unme+"' ");
                
                session.setAttribute("flash_message","Password Changed go ahead and login!");
                session.setAttribute("flash_type","success");
                response.sendRedirect("newPassword.jsp");
            }else{
                session.setAttribute("flash_message","An error occured while reseting password!");
                session.setAttribute("flash_type","danger");
                response.sendRedirect("newPassword.jsp");
            }

        }catch(Exception ex){
            System.out.println("Exception while changing pass "+ex);
            ex.printStackTrace();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
