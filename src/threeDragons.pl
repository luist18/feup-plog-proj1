:- consult('menus.pl').
:- consult('board.pl').
:- consult('util.pl').
:- consult('game.pl').
:- consult('input.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

play :- main_menu.