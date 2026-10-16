from fastapi import FastAPI, Depends
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import declarative_base, sessionmaker, Session
from pydantic import BaseModel

# Conexión apuntando a tu contenedor Docker local con tus credenciales
DATABASE_URL = "postgresql://adrian:adrian123@localhost:5432/users_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Modelo de SQLAlchemy (Estructura de la tabla en la base de datos)
class UserDB(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    phone = Column(String, unique=True, index=True)

# Esquemas de Pydantic (Validación de datos para la API)
class UserBase(BaseModel):
    name: str
    phone: str

class UserResponse(UserBase):
    id: int

    class Config:
        from_attributes = True

app = FastAPI(title="Users API Local")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Endpoints
@app.get("/users/", response_model=list[UserResponse])
def get_users(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    """Obtiene la lista de usuarios."""
    return db.query(UserDB).offset(skip).limit(limit).all()

@app.post("/users/", response_model=UserResponse)
def create_user(user: UserBase, db: Session = Depends(get_db)):
    """Crea un nuevo usuario."""
    db_user = UserDB(name=user.name, phone=user.phone)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user