from flask import Flask, jsonify
from dotenv import load_dotenv
from .extensions import db, jwt
from .routes import auth, turfs, bookings, payments
from .models import Turf
from .database import get_database_uri


def create_app():
    load_dotenv()
    app = Flask(__name__)

    app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "dev")
    app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "dev")
    app.config["SQLALCHEMY_DATABASE_URI"] = get_database_uri()
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)
    jwt.init_app(app)

    app.register_blueprint(auth.bp)
    app.register_blueprint(turfs.bp)
    app.register_blueprint(bookings.bp)
    app.register_blueprint(payments.bp)

    @app.get("/health")
    def health():
        return jsonify({"status": "ok"})

    @app.before_first_request
    def _init_db():
        db.create_all()
        _seed_turfs()

    return app


def _seed_turfs():
    if Turf.query.first():
        return

    sample = [
        Turf(name="Arena 5-a-Side", location="Ring Road, Vadodara", rating="4.3", price="₹800/hr", tags="FOOTBALL,CRICKET,OUTDOOR", is_open=True),
        Turf(name="Thunder Box Cricket", location="Alkapuri, Vadodara", rating="4.8", price="₹1200/hr", tags="CRICKET,FOOTBALL,OUTDOOR", is_open=True),
        Turf(name="Court Pro Badminton", location="Gotri, Vadodara", rating="4.6", price="₹500/hr", tags="BADMINTON,INDOOR", is_open=True),
        Turf(name="SportsPlex Indoor", location="Manjalpur, Vadodara", rating="4.2", price="₹1000/hr", tags="BASKETBALL,BADMINTON,INDOOR", is_open=False),
    ]
    db.session.add_all(sample)
    db.session.commit()


app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
