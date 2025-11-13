package br.com.fiap.skillbridge.ai.shared.exception;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.*;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
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

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleGeneric(Exception ex, HttpServletRequest req){
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ApiError(
                Instant.now(), 500, "Internal Server Error", ex.getMessage(), req.getRequestURI(), List.of()
        ));
    }
}
