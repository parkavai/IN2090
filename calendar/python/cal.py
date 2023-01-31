import psycopg2
from datetime import date

dbname = "" # Sett inn ditt UiO-brukernavn
user = "" # Sett inn ditt UiO-brukernavn + _priv
pwd = "" # Sett inn passorder til _priv-brukeren du fikk i email

# Samle all info i en streng
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"


def main():
    conn = psycopg2.connect(connection)
    today(conn)

    while(True):
        print("\n\n-- MENU --\n1. Add event\n2. Show events for date\n3. Exit")
        ch = get_int_from_user("Option: ", True)
        if (ch == 1):
            add_event(conn)
        elif (ch == 2):
            show_events(conn)
        else:
            return
    
def show(conn, day):
    cur = conn.cursor()
    cur.execute("select eid, event, starts::time, ends::time " + \
            "from calendar " + \
            "where (starts, ends) overlaps (%s, %s + '1 day'::interval);", (day, day))

    row = cur.fetchone()
    while row is not None:
        print("[" + str(row[0]) + "] " + row[1] + ": " + str(row[2]) + " - " + str(row[3]))
        row = cur.fetchone()
    # Kan også bruke cur.fetchall() for å hente ut alt, men bør kun gjøres dersom
    # det er få resultater, siden alt lastes inn i minne samtidig. Koden blir da:
    #
    # rows = cur.fetchall()
    # for row in rows:
    #     print("[" + str(row[0]) + "] " + row[1] + ": " + str(row[2]) + " - " + str(row[3]))

def today(conn):
    print("-- TODAY'S EVENTS --")
    show(conn, date.today())

def show_events(conn):
    print("-- SHOW EVENTS --")
    datestr = input("Date: ")
    show(conn, date.fromisoformat(datestr))

def add_event(conn):
    print("-- ADD EVENT --")
    event = input("Event: ")
    starts = input("Starts: ")
    ends = input("Ends: ")

    cur = conn.cursor()
    cur.execute("INSERT INTO calendar(event, starts, ends) VALUES (%s, %s, %s);", (event, starts, ends))
    conn.commit()
    print("Event added.")

def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as message
    # Second argument is boolean, and if false allows user to not give input, and will then
    # return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None;
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.");


if __name__ == "__main__":
    main()

