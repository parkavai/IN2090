import psycopg2

# MERK: Må kjøres med Python 3!

# Login details for database user
dbname = "" #Set in your UiO-username
user = "" # Set in your priv-user (UiO-username + _priv)
pwd = "" # Set inn the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

def administrator():
    conn = psycopg2.connect(connection)
    
    ch = 0
    while (ch != 3):
        print("-- ADMINISTRATOR --")
        print("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit")
        ch = get_int_from_user("Option: ", True)

        if (ch == 1):
            make_bills(conn)
        elif (ch == 2):
            insert_product(conn)
    
def make_bills(conn):
    # Oppg 2
    print("-- CREATE BILLS --")
    cur = conn.cursor()
    cur.execute("SELECT u.name, u.address, SUM(o.num + p.price) AS total " + \
                "FROM ws.users AS u " + \
                    "INNER JOIN ws.orders AS o ON u.uid = o.uid " + \
                    "INNER JOIN ws.products AS p on o.pid = p.pid " + \
                "WHERE o.payed = 0 " + \
                "GROUP BY u.name, u.address " + \
                "HAVING SUM(o.num + p.price) > 0;")
    rows = cur.fetchall()

    if (rows == []):
        print("No results.")
        return

    for row in rows:
        if (str(row[2]) != "NULL"):
            print("=== " + "Bill" + " ===\n" + \
                "Name: " + str(row[0]) + "\n" + \
                "Address: " + str(row[1]) + "\n" + \
                "Total due: " + str(row[2]))
        print("\n")
    conn.commit()

def insert_product(conn):
    # Oppg 3
    print("-- ADD PRODUCT --")
    produktnavn = (input("Product name: "))
    pris = (input("Price: "))
    kategori = (input("Category: "))
    beskrivelse = (input("Description: "))

    cur = conn.cursor()
    cur.execute("INSERT INTO ws.products(name, price, cid, description) VALUES (%s, %s, (SELECT cid FROM ws.categories as c WHERE c.name = %s), %s);", (produktnavn, pris, kategori, beskrivelse))
    conn.commit()
    print("New product " + produktnavn + " inserted.")

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
    administrator()
