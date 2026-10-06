package com.warranty.dtos;

import java.time.LocalDate;

public record WarrantyResponse(
    Long id,
    String userId,
    String productName,
    LocalDate purchaseDate,
    Integer warrantyDurationMonths,
    String retailer,
    Double price,
    LocalDate expirationDate,
    String status
) {
    public static WarrantyResponse from(com.warranty.models.Warranty warranty) {
        long daysUntil = java.time.Duration.between(
            java.time.LocalDateTime.now(),
            warranty.getExpirationDate().atStartOfDay()
        ).toDays();

        String status;
        if (daysUntil < 0) {
            status = "expired";
        } else if (daysUntil <= 30) {
            status = "critical";
        } else if (daysUntil <= 60) {
            status = "expiring";
        } else {
            status = "active";
        }

        return new WarrantyResponse(
            warranty.getId(),
            warranty.getUserId(),
            warranty.getProductName(),
            warranty.getPurchaseDate(),
            warranty.getWarrantyDurationMonths(),
            warranty.getRetailer(),
            warranty.getPrice(),
            warranty.getExpirationDate(),
            status
        );
    }
}