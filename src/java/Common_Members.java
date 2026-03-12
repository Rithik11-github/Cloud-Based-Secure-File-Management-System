/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package DATA;

import java.sql.*;

/**
 *
 * @author SA
 */
public interface Common_Members {

    public String Driver_Register = "com.mysql.jdbc.Driver";
    public String DB_Uname = "root";
    public String DB_Upass = "admin";
    //Local Server Variables
    public String DB_Path = "jdbc:mysql://localhost:3306/ip";
    //Remote Server - 1 Variables   
   
    //Methods

    public Connection Make_Connection();

    public ResultSet Select(String Query);

    public int Insert(String Query);

    public int Update(String Query);

    public int Delete(String Query);
}
