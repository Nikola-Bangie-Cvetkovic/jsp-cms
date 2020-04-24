package com.example.cms.database.dao;

import com.example.cms.database.entity.Tag;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.NoResultException;
import javax.persistence.Persistence;

public class TagDAO extends AbstractDAO<Tag> {
	private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("blogpu");
	private final EntityManager em = emf.createEntityManager();

	public TagDAO() {
		super(Tag.class);
	}

	@Override
	protected EntityManager getEntityManager() {
		return em;
	}

	public Tag findByName(final String name) {
		final String query = "select t from Tag t where t.name = :name";
		try {
			return getEntityManager().createQuery(query, Tag.class)
					.setParameter("name", name)
					.getSingleResult();
		} catch (NoResultException e) {
			e.printStackTrace();
			return null;
		}
	}
}
