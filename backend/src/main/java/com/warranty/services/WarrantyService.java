package com.warranty.services;

import com.warranty.models.Warranty;
import com.warranty.repositories.WarrantyRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class WarrantyService {

    private final WarrantyRepository warrantyRepository;

    public WarrantyService(WarrantyRepository warrantyRepository) {
        this.warrantyRepository = warrantyRepository;
    }

    public Warranty createWarranty(Warranty warranty) {
        return warrantyRepository.save(warranty);
    }

    public List<Warranty> getWarrantiesByUserId(String userId) {
        return warrantyRepository.findByUserId(userId);
    }

    public Warranty getWarrantyById(String userId, Long id) {
        return warrantyRepository.findByUserIdAndId(userId, id)
            .orElseThrow(() -> new EntityNotFoundException("Warranty not found: " + id));
    }

    public Warranty updateWarranty(String userId, Long id, Warranty warrantyDetails) {
        Warranty warranty = getWarrantyById(userId, id);
        warranty.setProductName(warrantyDetails.getProductName());
        warranty.setPurchaseDate(warrantyDetails.getPurchaseDate());
        warranty.setWarrantyDurationMonths(warrantyDetails.getWarrantyDurationMonths());
        warranty.setRetailer(warrantyDetails.getRetailer());
        warranty.setPrice(warrantyDetails.getPrice());
        return warrantyRepository.save(warranty);
    }

    public void deleteWarranty(String userId, Long id) {
        Warranty warranty = getWarrantyById(userId, id);
        warrantyRepository.delete(warranty);
    }

    public List<Warranty> getExpiringWarranties(String userId) {
        return warrantyRepository.findExpiringWarranties(userId, java.time.LocalDate.now().plusDays(90));
    }
}