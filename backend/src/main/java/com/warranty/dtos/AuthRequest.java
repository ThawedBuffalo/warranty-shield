package com.warranty.dtos;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record AuthRequest(
    @NotBlank(message = "Firebase UID is required")
    String firebaseUid,

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    String email,

    String deviceToken
) {}