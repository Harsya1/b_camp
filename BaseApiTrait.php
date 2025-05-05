<?php

namespace App\Http\Controllers\Api;

use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

trait BaseApiTrait
{
    /**
     * Get the model class name.
     *
     * @return string
     */
    abstract protected function getModelClass();

    /**
     * Get validation rules for storing a new record.
     *
     * @return array
     */
    abstract protected function getStoreValidationRules();

    /**
     * Get validation rules for updating a record.
     *
     * @return array
     */
    abstract protected function getUpdateValidationRules();

    /**
     * Display all records.
     *
     * @return \Illuminate\Http\JsonResponse The data record or error message
     * 
     * @throws \Exception If there's an error during data retrieval
     * 
     * @response 200 {
     * "id": "1",
     * ...other attributes...
     * }
     * @response 500 Server error
     */
    public function index()
    {
        try {
            $modelClass = $this->getModelClass();
            $data = $modelClass::all();
            return response()->json($data, Response::HTTP_OK);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Server error: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request  The HTTP request containing data
     * 
     * @return \Illuminate\Http\JsonResponse The record or error message
     *
     * @throws \Exception When an error occurs during record creation
     * 
     * @response 201 {
     *    "id": 1,
     *   ...other attributes...
     * }
     * @response 422 Data validation error
     * @response 500 Server error
     */
    public function store(Request $request)
    {
        try {
            $validator = \Validator::make($request->all(), $this->getStoreValidationRules());

            if ($validator->fails()) {
                return response()->json(
                    ['error' => $validator->errors()->first()],
                    Response::HTTP_UNPROCESSABLE_ENTITY
                );
            }

            $validated = $request->all();
            $modelClass = $this->getModelClass();
            $create = $modelClass::create($validated);

            return response()->json($create, Response::HTTP_CREATED);
        } catch (\Exception $e) {
            return response()->json(
                ['error' => 'Failed to create record: ' . $e->getMessage()],
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }

    /**
     * Display the specified resource from.
     *
     * @param string $id The ID of the to retrieve
     * 
     * @return \Illuminate\Http\JsonResponse The record or error message
     *
     * @throws \Illuminate\Database\Eloquent\ModelNotFoundException If the record does not exist
     * @throws \Exception For any other server errors
     *
     * @response 200 {
     *  "id": "1",
     *  ...other attributes...
     * }
     * @response 404 { "error": "Record not found" }
     * @response 500 { "error": "Server error: [error message]" }
     */
    public function show(string $id)
    {
        try {
            $modelClass = $this->getModelClass();
            $record = $modelClass::findOrFail($id);
            return response()->json($record, Response::HTTP_OK);
        } catch (ModelNotFoundException $e) {
            return response()->json(
                ['error' => 'Record not found'],
                Response::HTTP_NOT_FOUND
            );
        } catch (\Exception $e) {
            return response()->json(
                ['error' => 'Server error: ' . $e->getMessage()],
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }

    /**
     * Update an existing record.
     *
     * @param  \Illuminate\Http\Request  $request  The HTTP request containing the updated data
     * @param  string  $id  The ID of the record to update
     * 
     * @return \Illuminate\Http\JsonResponse The record or error message
     *
     * @throws \Illuminate\Database\Eloquent\ModelNotFoundException If the record does not exist
     * @throws \Exception For any other server errors
     *
     * @response 200 {
     *     "id": 1,
     *    ...other attributes...
     * }
     * @response 404 Record not found
     * @response 422 Data validation error
     * @response 500 Server error
     */
    public function update(Request $request, string $id)
    {
        try {
            $validator = \Validator::make($request->all(), $this->getUpdateValidationRules());

            if ($validator->fails()) {
                return response()->json(
                    ['error' => $validator->errors()->first()],
                    Response::HTTP_UNPROCESSABLE_ENTITY
                );
            }

            $modelClass = $this->getModelClass();
            $record = $modelClass::findOrFail($id);
            $validated = $request->all();
            $record->update($validated);

            return response()->json($record, Response::HTTP_OK);
        } catch (ModelNotFoundException $e) {
            return response()->json(
                ['error' => 'Record not found'],
                Response::HTTP_NOT_FOUND
            );
        } catch (\Exception $e) {
            return response()->json(
                ['error' => 'Server error: ' . $e->getMessage()],
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }

    /**
     * Delete a record by ID.
     *
     * @param string $id The ID of the to delete
     * @return \Illuminate\Http\JsonResponse The record or error message
     * 
     * @throws \Illuminate\Database\Eloquent\ModelNotFoundException If the record does not exist
     * @throws \Exception For any other server errors
     */
    public function destroy(string $id)
    {
        try {
            $modelClass = $this->getModelClass();
            $delete = $modelClass::findOrFail($id);
            $delete->delete();

            return response()->json(
                ['message' => 'Record deleted successfully'],
                Response::HTTP_OK
            );
        } catch (ModelNotFoundException $e) {
            return response()->json(
                ['error' => 'Record not found'],
                Response::HTTP_NOT_FOUND
            );
        } catch (\Exception $e) {
            return response()->json(
                ['error' => 'Server error: ' . $e->getMessage()],
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }
}
