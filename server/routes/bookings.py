from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..extensions import db
from ..models import Booking, Turf, Payment

bp = Blueprint("bookings", __name__, url_prefix="/bookings")


@bp.get("")
@jwt_required()
def list_bookings():
    user_id = get_jwt_identity()
    bookings = Booking.query.filter_by(user_id=user_id).order_by(Booking.id.desc()).all()
    return jsonify([
        {
            "id": b.id,
            "turf_id": b.turf_id,
            "sport": b.sport,
            "date": b.date,
            "time_slot": b.time_slot,
            "duration": b.duration,
            "total_amount": b.total_amount,
            "status": b.status,
        }
        for b in bookings
    ])


@bp.post("")
@jwt_required()
def create_booking():
    user_id = get_jwt_identity()
    data = request.get_json(silent=True) or {}
    turf_id = data.get("turf_id")
    sport = data.get("sport")
    date = data.get("date")
    time_slot = data.get("time_slot")
    duration = data.get("duration")
    total_amount = data.get("total_amount")
    payment_method = data.get("payment_method")

    if not all([turf_id, sport, date, time_slot, duration, total_amount, payment_method]):
        return jsonify({"error": "missing booking fields"}), 400

    turf = Turf.query.get(turf_id)
    if not turf:
        return jsonify({"error": "turf not found"}), 404

    booking = Booking(
        user_id=user_id,
        turf_id=turf_id,
        sport=sport,
        date=date,
        time_slot=time_slot,
        duration=int(duration),
        total_amount=int(total_amount),
        status="PAID",
    )
    db.session.add(booking)
    db.session.flush()

    payment = Payment(
        booking_id=booking.id,
        method=payment_method,
        amount=int(total_amount),
        status="PAID",
    )
    db.session.add(payment)
    db.session.commit()

    return jsonify({"id": booking.id, "status": booking.status}), 201
