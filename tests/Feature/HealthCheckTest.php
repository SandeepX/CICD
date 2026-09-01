<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;

class HealthCheckTest extends TestCase
{
    /**
     * A basic test for health check endpoint.
     */
    public function test_health_check_returns_200(): void
    {
        $response = $this->getJson('/api/health');

        $response->assertStatus(200)
                 ->assertJson([
                     'status' => 'healthy',
                 ]);
    }

    /**
     * Test health check includes timestamp
     */
    public function test_health_check_includes_timestamp(): void
    {
        $response = $this->getJson('/api/health');

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'status',
                     'timestamp',
                     'environment',
                     'version',
                 ]);
    }

    /**
     * Test detailed health check endpoint
     */
    public function test_detailed_health_check_returns_200(): void
    {
        $response = $this->getJson('/api/health/detailed');

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'status',
                     'timestamp',
                     'checks',
                 ]);
    }
}
