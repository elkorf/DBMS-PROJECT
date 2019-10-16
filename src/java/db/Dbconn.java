package db;

import java.sql.Connection;
import java.sql.DriverManager;



public class Dbconn {
    static Connection connection ;

    public static Connection connect() throws Exception {
       
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/sig_management","root", "");            
            return connection;
        } catch (Exception e) {
            System.out.println("Exception in datbase connection : " + e.toString());
            
        }
        return null;
    }
}