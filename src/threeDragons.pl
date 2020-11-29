:- consult('util.pl').
:- consult('menus.pl').
:- consult('board.pl').
:- consult('input.pl').
:- consult('movement.pl').
:- consult('game.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

:- dynamic(state/4).

play :- main_menu.