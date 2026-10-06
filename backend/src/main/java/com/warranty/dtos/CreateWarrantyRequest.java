package com.warranty.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.LocalDate;

public record CreateWarrantyRequest(
    @NotBlank(message = "Product name is required")
    String productName,

    @NotNull(message = "Purchase date is required")
    LocalDate purchaseDate,

    @NotNull(message = "Warranty duration (months) is required")
    @Positive(message = "Duration must be positive")
    Integer warrantyDurationMonths,

    @NotBlank(message = "Retailer is required")
    String retailer,

    @NotNull(message = "Price is required")
    @Positive(message = "Price must be positive")
    Double price
) {}