CREATE TABLE "RIDERS" (
	"rider_id" INTEGER NOT NULL UNIQUE,
	"email" VARCHAR(255) NOT NULL UNIQUE,
	"phone" VARCHAR(255) NOT NULL UNIQUE,
	"name" VARCHAR(255) NOT NULL,
	"age" VARCHAR(255),
	"profile_image_url" VARCHAR(255),
	"is_active" BOOLEAN,
	"created_at" TIMESTAMP,
	PRIMARY KEY("rider_id")
);

CREATE TABLE "RIDES" (
	"ride_id" INTEGER NOT NULL UNIQUE,
	"rider_id" INTEGER NOT NULL,
	"driver_id" INTEGER NOT NULL,
	"vehicle_id" INTEGER NOT NULL,
	"zone_id" INTEGER NOT NULL,
	"pickup_latitude" DECIMAL,
	"pickup_longitude" DECIMAL,
	"pickup_address" VARCHAR(255),
	"destination_latitude" DECIMAL,
	"destination_longitude" DECIMAL,
	"destination_address" VARCHAR(255),
	"requested_vehicle_type" VARCHAR(255),
	"status" TEXT,
	"estimated_fare" DECIMAL,
	"final_fare" DECIMAL,
	"distance_km" DECIMAL,
	"duration_minutes" INTEGER,
	"requested_at" TIMESTAMP,
	"matched_at" TIMESTAMP,
	"pickup_at" TIMESTAMP,
	"completed_at" TIMESTAMP,
	"cancelled_at" TIMESTAMP,
	PRIMARY KEY("ride_id")
);

CREATE TABLE "DRIVERS" (
	"driver_id" INTEGER NOT NULL UNIQUE,
	"email" VARCHAR(255) NOT NULL UNIQUE,
	"phone" VARCHAR(255) NOT NULL UNIQUE,
	"name" TEXT,
	"license_number" VARCHAR(255) NOT NULL UNIQUE,
	"profile_image_url" VARCHAR(255),
	"rating" VARCHAR(255),
	"total_ride" INTEGER,
	"is_active" BOOLEAN,
	"is_online" BOOLEAN,
	"created_at" TIMESTAMP,
	PRIMARY KEY("driver_id")
);

CREATE TABLE "VEHICLES" (
	"vehicle_id" INTEGER NOT NULL UNIQUE,
	"driver_id" INTEGER NOT NULL,
	"license_plate" VARCHAR(255) NOT NULL UNIQUE,
	"company" VARCHAR(255),
	"model" VARCHAR(255),
	"year" DATE,
	"color" VARCHAR(255),
	"vehicle_type" VARCHAR(255),
	"seats" INTEGER,
	"is_active" BOOLEAN NOT NULL,
	PRIMARY KEY("vehicle_id")
);

CREATE TABLE "DRIVER_LOCATIONS" (
	"location_id" INTEGER NOT NULL UNIQUE,
	"driver_id" INTEGER NOT NULL,
	"latitude" DECIMAL NOT NULL,
	"longitude" DECIMAL NOT NULL,
	"heading" INTEGER,
	"speed_kph" DECIMAL,
	"accuracy_meters" DECIMAL,
	"updated_at" TIMESTAMP NOT NULL,
	PRIMARY KEY("location_id")
);

CREATE TABLE "PRICING_ZONES" (
	"zone_id" INTEGER NOT NULL UNIQUE,
	"zone_name" VARCHAR(255) NOT NULL,
	"boundary_polygon" VARCHAR(255),
	"base_rate_per_km" DECIMAL NOT NULL,
	"base_rate_per_minute" DECIMAL NOT NULL,
	"minimum_fare" DECIMAL NOT NULL,
	"is_active" BOOLEAN NOT NULL,
	PRIMARY KEY("zone_id")
);

CREATE TABLE "SURGE_PRICING" (
	"surge_id" INTEGER NOT NULL UNIQUE,
	"zone_id" INTEGER NOT NULL,
	"multiplier" DECIMAL,
	"start_time" TIMESTAMP NOT NULL,
	"end_time" TIMESTAMP NOT NULL,
	PRIMARY KEY("surge_id")
);

CREATE TABLE "RATINGS" (
	"rating_id" INTEGER NOT NULL UNIQUE,
	"ride_id" INTEGER NOT NULL,
	"rater_type" VARCHAR(255),
	"rater_id" INTEGER NOT NULL,
	"ratee_type" VARCHAR(255),
	"ratee_id" INTEGER NOT NULL,
	"stars" DECIMAL NOT NULL,
	"comments" VARCHAR(255),
	"created_at" TIMESTAMP NOT NULL,
	PRIMARY KEY("rating_id")
);

CREATE TABLE "PAYMENTS" (
	"payment_id" INTEGER NOT NULL UNIQUE,
	"ride_id" INTEGER NOT NULL,
	"amount" DECIMAL NOT NULL,
	"payment_method" VARCHAR(255) NOT NULL,
	"status" VARCHAR(255) NOT NULL,
	"gateway_transaction_id" VARCHAR(255) NOT NULL,
	"failure_reason" VARCHAR(255) NOT NULL,
	"processed_at" TIMESTAMP NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	PRIMARY KEY("payment_id")
);

ALTER TABLE "RIDES"
ADD FOREIGN KEY("rider_id") REFERENCES "RIDERS"("rider_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "RIDES"
ADD FOREIGN KEY("driver_id") REFERENCES "DRIVERS"("driver_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "RIDES"
ADD FOREIGN KEY("vehicle_id") REFERENCES "VEHICLES"("vehicle_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "RIDES"
ADD FOREIGN KEY("zone_id") REFERENCES "PRICING_ZONES"("zone_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "DRIVER_LOCATIONS"
ADD FOREIGN KEY("driver_id") REFERENCES "DRIVERS"("driver_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "SURGE_PRICING"
ADD FOREIGN KEY("zone_id") REFERENCES "PRICING_ZONES"("zone_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "RATINGS"
ADD FOREIGN KEY("ride_id") REFERENCES "RIDES"("ride_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "PAYMENTS"
ADD FOREIGN KEY("ride_id") REFERENCES "RIDES"("ride_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

-- Indexes on foreign key columns
CREATE INDEX "idx_rides_rider_id" ON "RIDES"("rider_id");
CREATE INDEX "idx_rides_driver_id" ON "RIDES"("driver_id");
CREATE INDEX "idx_rides_vehicle_id" ON "RIDES"("vehicle_id");
CREATE INDEX "idx_rides_zone_id" ON "RIDES"("zone_id");
CREATE INDEX "idx_driver_locations_driver_id" ON "DRIVER_LOCATIONS"("driver_id");
CREATE INDEX "idx_surge_pricing_zone_id" ON "SURGE_PRICING"("zone_id");
CREATE INDEX "idx_ratings_ride_id" ON "RATINGS"("ride_id");
CREATE INDEX "idx_payments_ride_id" ON "PAYMENTS"("ride_id");