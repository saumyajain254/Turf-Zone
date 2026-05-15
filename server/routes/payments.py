from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..models import Booking, Payment

bp = Blueprint("payments", __name__, url_prefix="/payments")


@bp.get("")
@jwt_required()
def list_payments():
    user_id = get_jwt_identity()
    payments = Payment.query.join(Booking, Payment.booking_id == Booking.id)
    payments = payments.filter(Booking.user_id == user_id).order_by(Payment.id.desc()).all()
    return jsonify([
        {
            "id": p.id,
            "booking_id": p.booking_id,
            "method": p.method,
            "amount": p.amount,
            "status": p.status,
        }
        for p in payments
    ])
