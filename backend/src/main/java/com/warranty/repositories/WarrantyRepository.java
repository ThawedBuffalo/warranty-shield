package com.warranty.repositories;

import com.warranty.models.Warranty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface WarrantyRepository extends JpaRepository<Warranty, Long> {

    List<Warranty> findByUserId(String userId);

    @Query("SELECT w FROM Warranty w WHERE w.userId = :userId AND w.expirationDate <= :date ORDER BY w.expirationDate ASC")
    List<Warranty> findExpiringWarranties(@Param("userId") String userId, @Param("date") LocalDate date);

    Optional<Warranty> findByUserIdAndId(String userId, Long id);

    boolean existsByUserIdAndProductName(String userId, String productName);
}