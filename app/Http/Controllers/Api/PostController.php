<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class PostController extends Controller
{
    /**
     * Display a listing of posts
     */
    public function index(): JsonResponse
    {
        // Sample posts data for CI/CD demo
        $posts = [
            ['id' => 1, 'title' => 'Learning CI/CD', 'content' => 'This is a demo post'],
            ['id' => 2, 'title' => 'Docker Basics', 'content' => 'Understanding containers'],
            ['id' => 3, 'title' => 'GitHub Actions', 'content' => 'Automating workflows'],
        ];

        return response()->json([
            'success' => true,
            'data' => $posts,
        ]);
    }

    /**
     * Store a new post
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Post created successfully',
            'data' => $validated,
        ], 201);
    }

    /**
     * Display the specified post
     */
    public function show($id): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'id' => $id,
                'title' => 'Sample Post',
                'content' => 'This is a sample post content',
            ],
        ]);
    }
}
