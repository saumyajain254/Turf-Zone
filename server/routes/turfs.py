from flask import Blueprint, jsonify
from ..models import Turf

bp = Blueprint("turfs", __name__, url_prefix="/turfs")


@bp.get("")
def list_turfs():
    turfs = Turf.query.order_by(Turf.id.asc()).all()
    return jsonify([
        {
            "id": t.id,
            "name": t.name,
            "location": t.location,
            "rating": t.rating,
            "price": t.price,
            "tags": t.tags.split(",") if t.tags else [],
            "is_open": t.is_open,
        }
        for t in turfs
    ])
