
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="FSI Bootcamp API", version="0.1")

class Trade(BaseModel):
    trade_id: str
    qty: int
    price: float

@app.get('/health')
def health():
    return {"status":"ok"}

@app.post('/capital-markets/signal')
def cm_signal(t: Trade):
    notional = t.qty * t.price
    return {"trade_id": t.trade_id, "notional": notional, "anomaly_flag": int(notional>250000)}

@app.post('/insurance/fraud-score')
def insurance_score(payload: dict):
    # Placeholder scoring
    score = 0.3 if payload.get('estimated_loss',0) < 5000 else 0.7
    return {"fraud_score": score}

@app.post('/banking/advisor')
def advisor_reco(payload: dict):
    risk = payload.get('risk_profile','Balanced')
    reco = 'Treasury ETF' if risk=='Conservative' else ('Balanced Index' if risk=='Balanced' else 'Tech Growth Fund')
    return {"recommendation": reco}
