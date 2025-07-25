import sqlite3 from 'sqlite3';
import sha256 from 'sha256';

const DBSOURCE = "db.sqlite";
sqlite3.verbose();

let db = new sqlite3.Database(DBSOURCE, err => {
    if (err) {
        // Cannot open database
        console.error(err.message)
        throw err
    } else {
        console.log('Connected to the SQLite database.')
        db.run(`CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT, 
            email TEXT UNIQUE, 
            password TEXT, 
            CONSTRAINT email_unique UNIQUE (email)
            )`,
            (err) => {
                if (err) {
                    // Table already created
                    console.log('Error on create table user', err.message);
                    return
                } else {
                    // Table just created, creating some rows
                    var insert = 'INSERT INTO user (name, email, password) VALUES (?,?,?)'
                    db.run(insert, ["admin", "ade@gmail.com", sha256("ade")])
                    db.run(insert, ["user", "user@example.com", sha256("P@ssw0rd")])
                }
            });
        console.log('Continue create table products');
        db.run(`CREATE TABLE product (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                description TEXT,
                price REAL,
                discountPercentage REAL,
                rating REAL,
                stock INTEGER,
                brand TEXT,
                category TEXT,
                thumbnail TEXT,
                images TEXT,
                CONSTRAINT title_unique UNIQUE (title)
            )`, err => {
            if (err) {
                console.log('Error on create table product', err.message);
                return
            } else {
                var insert = `INSERT INTO product (title, description, price, discountPercentage,rating, stock,brand,category,thumbnail,images) 
                VALUES (?,?,?,?,?,?,?,?,?,?)`;
                // Sample Shoe Data
                db.run(insert, ["Nike Air Max 270", "Stylish and comfortable Nike Air Max 270 with revolutionary air unit.", 150.00, 10.00, 4.7, 50, "Nike", "shoes", "assets/images/NikeAirMax270.png", "assets/images/NikeAirMax270.png"]);
                db.run(insert, ["Adidas Ultraboost 22", "High-performance running shoes from Adidas with Boost cushioning.", 180.00, 5.00, 4.8, 30, "Adidas", "shoes", "assets/images/AdidasUltraboost22.png", "assets/images/AdidasUltraboost22.png"]);
                db.run(insert, ["Puma RS-X Reinvention", "Retro-inspired sneakers with a chunky design and vibrant colors.", 110.00, 8.00, 4.5, 40, "Puma", "shoes", "assets/images/PumaRS-XReinvention.png", "assets/images/PumaRS-XReinvention.png"]);
                db.run(insert, ["Converse Chuck Taylor All Star", "Classic and iconic high-top sneakers perfect for everyday wear.", 60.00, 0.00, 4.6, 100, "Converse", "shoes", "assets/images/ConverseChuckTaylorAllstar.jpg", "assets/images/ConverseChuckTaylorAllstar.jpg"]);
                db.run(insert, ["Vans Old Skool", "Timeless skate shoes with durable canvas and suede uppers.", 75.00, 0.00, 4.4, 70, "Vans", "shoes", "assets/images/VansOldSkool.jpg", "assets/images/VansOldSkool.jpg"]);
            }
        })
    }
});

export default db;