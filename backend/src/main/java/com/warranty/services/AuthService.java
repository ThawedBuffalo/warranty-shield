package com.warranty.services;

import com.warranty.dtos.AuthRequest;
import com.warranty.dtos.AuthResponse;
import com.warranty.models.User;
import com.warranty.repositories.UserRepository;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Base64;
import java.util.Optional;

@Service
public class AuthService {

    private final UserRepository userRepository;

    @Value("${app.jwt.secret}")
    private String jwtSecret;

    @Value("${app.jwt.expiration-ms:86400000}")
    private long jwtExpirationMs;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public AuthResponse authenticate(AuthRequest request) {
        // In production, verify the Firebase ID token here
        // For MVP, we trust the Firebase UID and create/register the user

        User user = userRepository.findByFirebaseUid(request.firebaseUid())
            .orElseGet(() -> userRepository.save(
                User.builder()
                    .email(request.email())
                    .firebaseUid(request.firebaseUid())
                    .deviceToken(request.deviceToken())
                    .build()
            ));

        // Update device token if provided
        if (request.deviceToken() != null) {
            user.setDeviceToken(request.deviceToken());
            userRepository.save(user);
        }

        String token = generateToken(user);
        return new AuthResponse(token, user.getEmail(), user.getFirebaseUid());
    }

    public Optional<User> getUserByFirebaseUid(String firebaseUid) {
        return userRepository.findByFirebaseUid(firebaseUid);
    }

    private String generateToken(User user) {
        SecretKey key = Keys.hmacShaKeyFor(Base64.getDecoder().decode(jwtSecret));

        return Jwts.builder()
            .subject(user.getFirebaseUid())
            .claim("email", user.getEmail())
            .claim("userId", user.getId())
            .issuedAt(new java.util.Date())
            .expiration(new java.util.Date(System.currentTimeMillis() + jwtExpirationMs))
            .signWith(key)
            .compact();
    }
}