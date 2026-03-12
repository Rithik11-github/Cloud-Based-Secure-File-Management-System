/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package DATA;

import static DATA.Common_Members.DB_Path;
import static DATA.Common_Members.DB_Uname;
import static DATA.Common_Members.DB_Upass;
import static DATA.Common_Members.Driver_Register;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author SA
 */
public class Access_DB implements Common_Members {

    public Connection con;
    public Statement st, st1;

    public Access_DB() throws SQLException {
        try {
            Class.forName(Driver_Register);
            con = DriverManager.getConnection(DB_Path, DB_Uname, DB_Upass);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("DB Connetor Constructor ERROR" + ex);
        }
    }

    @Override
    public Connection Make_Connection() {
        try {
            Class.forName(Driver_Register);
            con = DriverManager.getConnection(DB_Path, DB_Uname, DB_Upass);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("DB Connetor Constructor ERROR" + ex);
        } catch (SQLException ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }

    @Override
    public ResultSet Select(String Query) {
        ResultSet rs = null;
        try {
            st1 = (Statement) con.createStatement();
            st1.executeUpdate("set global max_connections=200");
            st = (Statement) con.createStatement();
            rs = st.executeQuery(Query);
        } catch (Exception ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Select() Method ERROR" + ex);
        }
        return rs;
    }

    @Override
    public int Insert(String Query) {
        int t = 0;
        try {
            st1 = (Statement) con.createStatement();
            st1.executeUpdate("set global max_connections=200");
            st = (Statement) con.createStatement();
            t = st.executeUpdate(Query);
        } catch (Exception ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Insert() Method ERROR" + ex);
        }
        return t;
    }

    @Override
    public int Update(String Query) {
        int t = 0;
        try {
            st1 = (Statement) con.createStatement();
            st1.executeUpdate("set global max_connections=200");
            st = (Statement) con.createStatement();
            t = st.executeUpdate(Query);
        } catch (Exception ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Update() Method ERROR" + ex);
        }
        return t;
    }

    @Override
    public int Delete(String Query) {
        int t = 0;
        try {
            st1 = (Statement) con.createStatement();
            st1.executeUpdate("set global max_connections=200");
            st = (Statement) con.createStatement();
            t = st.executeUpdate(Query);
        } catch (Exception ex) {
            Logger.getLogger(Access_DB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Delete() Method ERROR" + ex);
        }
        return t;
    }
}
