package com.warranty.controllers;

import com.warranty.dtos.AuthRequest;
import com.warranty.dtos.AuthResponse;
import com.warranty.services.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/authenticate")
    public ResponseEntity<AuthResponse> authenticate(
        @Valid @RequestBody AuthRequest request) {

        AuthResponse response = authService.authenticate(request);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}