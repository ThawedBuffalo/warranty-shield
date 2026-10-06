package com.warranty.controllers;

import com.warranty.dtos.CreateWarrantyRequest;
import com.warranty.dtos.WarrantyResponse;
import com.warranty.models.Warranty;
import com.warranty.services.WarrantyService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/warranties")
public class WarrantyController {

    private final WarrantyService warrantyService;

    public WarrantyController(WarrantyService warrantyService) {
        this.warrantyService = warrantyService;
    }

    @PostMapping
    public ResponseEntity<WarrantyResponse> createWarranty(
        @RequestHeader("X-User-Id") String userId,
        @Valid @RequestBody CreateWarrantyRequest request) {

        Warranty warranty = Warranty.builder()
            .userId(userId)
            .productName(request.productName())
            .purchaseDate(request.purchaseDate())
            .warrantyDurationMonths(request.warrantyDurationMonths())
            .retailer(request.retailer())
            .price(request.price())
            .build();

        Warranty saved = warrantyService.createWarranty(warranty);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(WarrantyResponse.from(saved));
    }

    @GetMapping
    public ResponseEntity<List<WarrantyResponse>> getWarranties(
        @RequestHeader("X-User-Id") String userId) {

        List<WarrantyResponse> warranties = warrantyService.getWarrantiesByUserId(userId)
            .stream()
            .map(WarrantyResponse::from)
            .collect(Collectors.toList());

        return ResponseEntity.ok(warranties);
    }

    @GetMapping("/{id}")
    public ResponseEntity<WarrantyResponse> getWarranty(
        @RequestHeader("X-User-Id") String userId,
        @PathVariable Long id) {

        Warranty warranty = warrantyService.getWarrantyById(userId, id);
        return ResponseEntity.ok(WarrantyResponse.from(warranty));
    }

    @PutMapping("/{id}")
    public ResponseEntity<WarrantyResponse> updateWarranty(
        @RequestHeader("X-User-Id") String userId,
        @PathVariable Long id,
        @Valid @RequestBody CreateWarrantyRequest request) {

        Warranty updated = warrantyService.updateWarranty(userId, id,
            Warranty.builder()
                .productName(request.productName())
                .purchaseDate(request.purchaseDate())
                .warrantyDurationMonths(request.warrantyDurationMonths())
                .retailer(request.retailer())
                .price(request.price())
                .build());

        return ResponseEntity.ok(WarrantyResponse.from(updated));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteWarranty(
        @RequestHeader("X-User-Id") String userId,
        @PathVariable Long id) {

        warrantyService.deleteWarranty(userId, id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/expiring")
    public ResponseEntity<List<WarrantyResponse>> getExpiringWarranties(
        @RequestHeader("X-User-Id") String userId) {

        List<WarrantyResponse> warranties = warrantyService.getExpiringWarranties(userId)
            .stream()
            .map(WarrantyResponse::from)
            .collect(Collectors.toList());

        return ResponseEntity.ok(warranties);
    }
}