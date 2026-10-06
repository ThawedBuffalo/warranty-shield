/// Backend Integration Tests for Warranty API
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)
/// Tests CRUD endpoints and expiration calculation.

package com.warranty;

import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import com.warranty.models.Warranty;
import com.warranty.repositories.WarrantyRepository;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.*;

@DataJpaTest
class WarrantyRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private WarrantyRepository warrantyRepository;

    @Test
    void testCreateWarranty() {
        Warranty warranty = new Warranty();
        warranty.setUserId("test-user-1");
        warranty.setProductName("MacBook Pro");
        warranty.setPurchaseDate(LocalDate.of(2024, 1, 15));
        warranty.setWarrantyDurationMonths(12);
        warranty.setRetailer("Apple Store");
        warranty.setPrice(1999.0);

        Warranty saved = warrantyRepository.save(warranty);
        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getExpirationDate()).isEqualTo(LocalDate.of(2025, 1, 15));
    }

    @Test
    void testFindExpiringWarranties() {
        // iPhone 15: expires within 90 days (will be found)
        Warranty w1 = new Warranty();
        w1.setUserId("test-user-1");
        w1.setProductName("iPhone 15");
        w1.setPurchaseDate(LocalDate.now().minusDays(335));
        w1.setWarrantyDurationMonths(11);
        w1.setRetailer("Best Buy");
        w1.setPrice(999.0);

        // iPad Air: expires in 2 years (will NOT be found)
        Warranty w2 = new Warranty();
        w2.setUserId("test-user-1");
        w2.setProductName("iPad Air");
        w2.setPurchaseDate(LocalDate.now().minusDays(365));
        w2.setWarrantyDurationMonths(24);
        w2.setRetailer("Apple Store");
        w2.setPrice(599.0);

        warrantyRepository.save(w1);
        warrantyRepository.save(w2);

        List<Warranty> expiring = warrantyRepository.findExpiringWarranties(
            "test-user-1",
            LocalDate.now().plusDays(90)
        );

        assertThat(expiring).hasSize(1);
        assertThat(expiring.get(0).getProductName()).isEqualTo("iPhone 15");
    }
}