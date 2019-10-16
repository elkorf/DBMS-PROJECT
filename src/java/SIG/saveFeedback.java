/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SIG;

import db.Dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author elkorf
 */
public class saveFeedback extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name=request.getParameter("name");
        String email=request.getParameter("email");
        String comment=request.getParameter("comment");
        try{
            Connection con = Dbconn.connect();
            Statement stSaveFeedback = con.createStatement();
            String sql="INSERT INTO feedback_details(name,email,comment) VALUES('"+name+"','"+email+"','"+comment+"')";
            stSaveFeedback.executeUpdate(sql);
        }catch(Exception exx){
            System.out.println("Exception occure while database connection "+exx);
        }
        response.sendRedirect("index.jsp");
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
