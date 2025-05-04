<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use App\Models\ModelEventforAPI;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Validator;

class EventAplikasiController extends Controller
{
    public function index()
    {
        try {
            $events = ModelEventforAPI::where('status', 'upcoming')
                ->orWhere('status', 'ongoing')
                ->orderBy('tanggal_mulai', 'asc')
                ->take(5)
                ->get();

            return response()->json([
                'status' => 'success',
                'data' => $events
            ], Response::HTTP_OK);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to fetch events: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_event' => 'required|string|max:255',
                'deskripsi' => 'nullable|string',
                'gambar' => 'nullable|string',
                'tanggal_mulai' => 'required|date',
                'tanggal_selesai' => 'nullable|date|after_or_equal:tanggal_mulai',
                'lokasi' => 'nullable|string',
                'status' => 'required|in:upcoming,ongoing,completed'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'message' => $validator->errors()
                ], Response::HTTP_UNPROCESSABLE_ENTITY);
            }

            $event = ModelEventforAPI::create($request->all());

            return response()->json([
                'status' => 'success',
                'message' => 'Event created successfully',
                'data' => $event
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to create event: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function show($id)
    {
        try {
            $event = ModelEventforAPI::findOrFail($id);
            return response()->json([
                'status' => 'success',
                'data' => $event
            ], Response::HTTP_OK);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Event not found'
            ], Response::HTTP_NOT_FOUND);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $event = ModelEventforAPI::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'nama_event' => 'string|max:255',
                'deskripsi' => 'nullable|string',
                'gambar' => 'nullable|string',
                'tanggal_mulai' => 'date',
                'tanggal_selesai' => 'nullable|date|after_or_equal:tanggal_mulai',
                'lokasi' => 'nullable|string',
                'status' => 'in:upcoming,ongoing,completed'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'message' => $validator->errors()
                ], Response::HTTP_UNPROCESSABLE_ENTITY);
            }

            $event->update($request->all());

            return response()->json([
                'status' => 'success',
                'message' => 'Event updated successfully',
                'data' => $event
            ], Response::HTTP_OK);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update event: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function destroy($id)
    {
        try {
            $event = ModelEventforAPI::findOrFail($id);
            $event->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Event deleted successfully'
            ], Response::HTTP_OK);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to delete event: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
