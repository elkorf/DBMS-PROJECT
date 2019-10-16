/*
    CURRENTLY WORKS ON IT DEPT ONLY
    LOGINPAGE IS COMPLETE
    SUCCESS/FAILURE MESSGAE DISPLAY SYTEM NOT YET WORKING

 background: linear-gradient(90deg, rgb(2, 31, 112), rgb(0, 132, 255));
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
import javax.servlet.http.HttpSession;

/**
 *
 * @author manas
 */
public class Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        }
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        processRequest(request, response);
    
        //response.setContentType("text/html;charset=UTF-8");
        HttpSession session=request.getSession(true);
        PrintWriter out=response.getWriter();
       
        String username=null,password=null;
        
        try 
        {          
            //GETTING PARAMETERS AND CONNECTING DATABASE
            
            username = request.getParameter("userid");
            password = request.getParameter("password");
            
            //CONNECTING DATABASE
            Dbconn db=new Dbconn();
            Connection con =db.connect();
            
            //import the password encryptor and encrypt it
            EncryptPass ep = new EncryptPass();
            password = ep.encrypt(password);
 
            //GENERATING QUERY
            String query = "Select * from users where user_id = '"+username+"' and password = '"+password+"';";
           
            Statement statement = con.createStatement();
            //VERIFYING USER-NAME AND PASSWORD
            ResultSet resultSet = statement.executeQuery(query);
            
            if (resultSet.next()) 
            {
            //SETTING SESSION ATTRIBUTES IF LOGIN IS SUCCESSFULL
                session.setAttribute("username",resultSet.getString("name"));   //name of user
                session.setAttribute("uid", username);                          //id of user
                session.setAttribute("email", resultSet.getString("email"));
                System.out.println("mail: "+resultSet.getString("email"));
                session.setAttribute("alert_message","Welcome!");
                session.setAttribute("alert_type","success");
                response.sendRedirect("home.jsp");
            } 
            else 
            {
            //UNSUCCESSFULL LOGIN
                //give message
                session.setAttribute("uid",null);
                session.setAttribute("alert_message","Invalid Credentials");
                session.setAttribute("alert_type","danger");
                System.out.println("login failed");
                response.sendRedirect("index.jsp#login");
            }
            con.close();//close the db connection
        } 
        catch (Exception ex) 
        {
            System.out.println("Exception while logging a user in: = \n"+ex);
            response.sendRedirect("index.jsp"); 
        }
        finally 
        {
            out.close();
        }
    }
}