#!/usr/bin/python3

from flask import Flask, request
from flask_restful import Api, Resource
import boto3


app = Flask(__name__)
api = Api(app)

client = boto3.client('dynamodb')

class Note(Resource):
    def get(self, note_id):
        # Read a note from the table
        return note, 200

    def put(self, note_id):
        # Update a note in the table
        return note, 201

    def delete(self, note_id):
        # Delete a note in the table
        return '', 204

class NoteList(Resource):
    def get(self):
        # Read the note list from the table
        return notes

    def post(self):
        # Create a note in the table
        note_id = '1'
        content = request.form['content']
        response = client.put_item(
            TableName='NoteTable',
            Item={
                'NoteId': {'N': note_id},
                'Content': {'S': content} 
            }
        )
        return response, 201


api.add_resource(NoteList, '/notes')
api.add_resource(Note, '/notes/<note_id>')


if __name__ == '__main__':
    app.run(debug=True)

