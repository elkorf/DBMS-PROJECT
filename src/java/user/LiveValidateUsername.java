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

/**
 *
 * @author manas
 */
public class LiveValidateUsername extends HttpServlet {

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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        
        PrintWriter out = response.getWriter();
        String strStatus = "Username is available";
        
        try{
            //System.out.println("Performing check");
            String username = request.getParameter("userName");
            
            //CONNECTING DATABASE
            Dbconn db=new Dbconn();
            Connection con =db.connect();
            
            String query = "SELECT * FROM users WHERE user_id='" + username +"'";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            boolean userExists = rs.next();
            
            if (userExists){
                strStatus = "Username Already Taken"; // Return Exist Msg
            }
        }catch(Exception e){
            strStatus = "Some error occured. Try again"; // Return Err Msg
            e.printStackTrace();
        }
        out.println(strStatus);
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
