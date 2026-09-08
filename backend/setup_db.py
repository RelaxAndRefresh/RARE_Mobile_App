"""Setup database - creates all tables from models directly."""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.db.database import engine
from app.db.base import Base

# Import all models to register them
from app.db.models import *  # noqa

print("Creating all tables...")
Base.metadata.create_all(bind=engine)
print("Done! All tables created.")
