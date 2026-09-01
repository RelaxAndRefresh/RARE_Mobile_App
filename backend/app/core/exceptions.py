from fastapi import Request, status
from fastapi.responses import JSONResponse


class RAREException(Exception):
    def __init__(self, message: str = "An error occurred", status_code: int = 500):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)


class AuthenticationError(RAREException):
    def __init__(self, message: str = "Authentication required"):
        super().__init__(message, status_code=status.HTTP_401_UNAUTHORIZED)


class AuthorizationError(RAREException):
    def __init__(self, message: str = "Insufficient permissions"):
        super().__init__(message, status_code=status.HTTP_403_FORBIDDEN)


class NotFoundError(RAREException):
    def __init__(self, message: str = "Resource not found"):
        super().__init__(message, status_code=status.HTTP_404_NOT_FOUND)


class ValidationError(RAREException):
    def __init__(self, message: str = "Validation failed"):
        super().__init__(message, status_code=status.HTTP_422_UNPROCESSABLE_ENTITY)


class ConflictError(RAREException):
    def __init__(self, message: str = "Resource already exists"):
        super().__init__(message, status_code=status.HTTP_409_CONFLICT)


async def rare_exception_handler(request: Request, exc: RAREException) -> JSONResponse:
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.message},
    )


exception_handlers = {
    RAREException: rare_exception_handler,
}
