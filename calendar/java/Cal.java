import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import java.util.Scanner;

public class Cal {


    public static void main(String[] agrs) {

        String dbname = ""; // Sett inn ditt UiO-brukernavn
        String user = ""; // Sett inn ditt UiO-brukernavn + _priv
        String pwd = ""; // Sett inn passord for _priv-brukeren du fikk i email
        
        // Tilkoblingsdetaljer
        String connectionStr = 
            "user=" + user + "&" + 
            "port=5432&" +  
            "password=" + pwd + "";

        String host = "jdbc:postgresql://dbpg-ifi-kurs01.uio.no"; 
        String connectionURL = 
            host + "/" + dbname +
            "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" +
            connectionStr;

        try {
            // Last inn driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Lag tilkobling til databasen
            Connection connection = DriverManager.getConnection(host + "/" + dbname
                    + "?" + connectionStr);

            today(connection);

            while (true) {
                System.out.println("\n\n-- MENU --\n1. Add event\n2. Show events for date\n3. Exit");
                int ch = getIntFromUser("Option: ", true);
                if (ch == 1) {
                    insertEvent(connection);
                } else if (ch == 2) {
                    showEvents(connection);
                } else {
                    return;
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println(ex.getMessage());
            return;
        }
    }

    private static void show(Connection connection, Date date) throws SQLException {

        PreparedStatement statement = connection.prepareStatement(
            "SELECT eid, event, starts::time, ends::time " + 
            "FROM calendar " + 
            "WHERE (starts, ends) OVERLAPS (?, ?::date + '1 day'::interval);"
        );
        statement.setDate(1, date);
        statement.setDate(2, date);
        ResultSet rows = statement.executeQuery();

        while (rows.next()) {
            System.out.println("[" + rows.getInt(1) + "] " + rows.getString(2) + ": " + rows.getTime(3) + " - " + rows.getTime(4));
        }
    }

    private static void today(Connection connection) throws SQLException {
        System.out.println("-- TODAY'S EVENTS --");
        show(connection, new Date(System.currentTimeMillis()));
    }

    private static void showEvents(Connection connection) throws SQLException {
        System.out.println("-- SHOW EVENTS --");
        String dateStr = getStrFromUser("Date: ");
        show(connection, Date.valueOf(dateStr));
    }

    private static void insertEvent(Connection connection) throws SQLException {

        System.out.println("-- ADD EVENT --");
        String event = getStrFromUser("Event: ");
        Timestamp starts = Timestamp.valueOf(getStrFromUser("Starts: "));
        Timestamp ends = Timestamp.valueOf(getStrFromUser("Ends: "));

        PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO calendar(event, starts, ends) VALUES (?, ?, ?)"
        );
        statement.setString(1, event);
        statement.setTimestamp(2, starts);
        statement.setTimestamp(3, ends);
        statement.execute();
        System.out.println("Event added.");
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}

