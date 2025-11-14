package br.com.fiap.skillbridge.ai.shared.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.*;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.*;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException ex, HttpServletRequest req){
        var fields = ex.getBindingResult().getFieldErrors()
                .stream().map(e -> e.getField() + ": " + e.getDefaultMessage()).toList();
        return ResponseEntity.badRequest().body(new ApiError(
                Instant.now(), 400, "Validation failed", "Dados inválidos", req.getRequestURI(), fields
        ));
    }

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(NotFoundException ex, HttpServletRequest req){
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ApiError(
                Instant.now(), 404, "Not Found", ex.getMessage(), req.getRequestURI(), List.of()
        ));
    }

    @ExceptionHandler({IllegalArgumentException.class, DataIntegrityViolationException.class})
    public ResponseEntity<ApiError> handleBadRequest(RuntimeException ex, HttpServletRequest req){
        return ResponseEntity.badRequest().body(new ApiError(
                Instant.now(), 400, "Bad Request", ex.getMessage(), req.getRequestURI(), List.of()
        ));
    }

    // 👇 NOVO: respeita o status da ResponseStatusException (409, 403, etc.)
    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ApiError> handleResponseStatus(ResponseStatusException ex, HttpServletRequest req){
        HttpStatusCode status = ex.getStatusCode();

        return ResponseEntity.status(status).body(new ApiError(
                Instant.now(),
                status.value(),
                status.toString(),          // ex.: "409 CONFLICT"
                ex.getReason(),             // ex.: "CONFLICT" ou tua mensagem
                req.getRequestURI(),
                List.of()
        ));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleGeneric(Exception ex, HttpServletRequest req){
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ApiError(
                Instant.now(), 500, "Internal Server Error", ex.getMessage(), req.getRequestURI(), List.of()
        ));
    }

}
