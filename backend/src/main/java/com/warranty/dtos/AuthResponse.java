package com.warranty.dtos;

public record AuthResponse(
    String token,
    String email,
    String firebaseUid
) {}